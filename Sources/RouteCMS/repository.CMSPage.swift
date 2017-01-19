import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

private struct RepositoryCMSPageDictCache {

    private static var cache: [String: [String:Any]] = [:]

    static func get(key: String) -> [String:Any]? {

        if let dictPage = self.cache[key] {
            return dictPage
        } else {
            return nil
        }

    }

    static func set(key: String, value: [String:Any]) {
        self.cache[key] = value
    }

    static func delete(key: String) {
        self.cache.removeValue(forKey: key)
    }

}

public class RepositoryCMSPage: OpenbuildMysql.OBMySQL {

    public init() throws {

        guard let connectionDetails = OpenbuildSingleton.Manager.getConnectionDetails(
            module: "cms",
            name: "cms",
            type: "mysql"
        )else{
            throw RepoError.connection(
                messagePublic: "Connection details not found for RouteCMS:CMSPage",
                messageDev: "Connection details not found for RouteCMS:CMSPage auth:role:mysql"
            )
        }

        try super.init(
                connectionParams: connectionDetails.connectionParams as! MySQLConnectionParams,
                database: connectionDetails.connectionDetails.db
        )

    }

    public func getByPath(path: String) throws -> ModelCMSPage? {

        if let pageDictCached = RepositoryCMSPageDictCache.get(key: path) {
            return self.pageIncludeContent(pageDict: pageDictCached)
        }

        let results = try select(
            statement: "SELECT * FROM cms_page WHERE uri = ?",
            params: [path]
        )

        if(results.count == 1){

            var pageDict = results[0]

            let resultsPageContentLinks = try select(
                statement: "SELECT * FROM cms_page_content WHERE cms_page_id = ?",
                params: [pageDict["cms_page_id"]!]
            )

            var variableMap: [String:Any] = [:]

            let selectSQL = String(current: #file, path: "SQL/cms_select.sql")

            for resultsPageContentLink in resultsPageContentLinks as [[String:Any]] {

                let linkResult = try select(
                    statement: selectSQL!,
                    params: [
                        resultsPageContentLink["cms_page_content_id"]!,
                        resultsPageContentLink["cms_page_content_id"]!
                    ]
                )

                if linkResult.count == 1 {

                    if resultsPageContentLink["is_list"]! as! Int8 == 0 {
                        variableMap[resultsPageContentLink["template_variable"]! as! String] = linkResult[0]
                    } else {
                        variableMap[resultsPageContentLink["template_variable"]! as! String] = linkResult
                    }
                    //TODO - LISTS

                } else if linkResult.count >= 2 {
                    variableMap[resultsPageContentLink["template_variable"]! as! String] = linkResult
                }

            }

            pageDict["variable_map"] = variableMap

            RepositoryCMSPageDictCache.set(key: path, value: pageDict)
            return self.pageIncludeContent(pageDict: pageDict)

        }

        return nil

    }

    private func pageIncludeContent(pageDict: [String: Any]) -> ModelCMSPage? {

print("pageDict")
print(pageDict as [String: Any])

        var pageDictIncContent = pageDict
        let variableMap = pageDict["variable_map"]! as! [String:Any]
        var contentDict: [String:Any] = [:]
print(pageDictIncContent)

        do{

            let repositoryCMSMarkdown = try RepositoryCMSMarkdown()
            let repositoryCMSWords = try RepositoryCMSWords()

            for (_, value) in variableMap.enumerated() {

print("value.value")
print(value.value as Any)

                if value.value is [String:Any] {
print("value.value is [String:Any]")
                    let contentItemDict = value.value as! [String:Any]

                    if contentItemDict["type"]! as! String == "markdown" {

                        let markdown = try repositoryCMSMarkdown.getByHandle(handle: contentItemDict["handle"]! as! String)

                        if markdown != nil {
                            contentDict[value.key] = markdown!.html!
                        } else {
                            contentDict[value.key] = nil
                        }

                    }

                } else if value.value is [[String:Any]] {
print("value.value is [[String:Any]]")

                    var variableList = [String]()

                    for multi in value.value as! [[String:Any]] {
                        print("multi")
                        print(multi as Any)
                        if multi["type"]! as! String == "markdown" {

                            let markdown = try repositoryCMSMarkdown.getByHandle(handle: multi["handle"]! as! String)

                            if markdown != nil {
                                variableList.append(markdown!.html!)
                            }

                        }

                    }

                    contentDict[value.key] = variableList

                } else {
                    contentDict[value.key] = nil
                }

            }

            pageDictIncContent["variables"] = contentDict

            return ModelCMSPage(dictionary: pageDictIncContent)

        } catch {
            return nil
        }

    }

    public func siteMap(name: String) throws -> [[String:Any]]? {
        return try select(
            statement: "SELECT CONCAT(?, uri) AS loc, DATE_FORMAT(updated, '%Y-%m-%dT%TZ') AS lastmod, 'weekly' AS changefreq, '0.8' AS priority FROM cms_page ORDER BY uri",
            params: [name]
        )
    }

    public func create(model: ModelCMSPage) -> ModelCMSPage {

        //FIXME / TODO - Transactions!

        let results = insert(
            statement: "INSERT INTO cms_page (uri, template_path, title, description) VALUES (?, ?, ?, ?)",
            params: [model.uri!, model.template_path!, model.title!, model.description!]
        )

        if results.error == false && results.affectedRows == 1{

            model.cms_page_id = Int(results.insertId!)

            for (_, variable) in model.variablesCreate.enumerated(){

                let variableDictionary = variable as! [String: Any]
                let variable = variableDictionary["variable"] as! String
                let contentArray = variableDictionary["content"] as! [[String:String]]
                let isList = contentArray.count == 1 ? 0 : 1

                let resultsContent = insert(
                    statement: "INSERT INTO cms_page_content (cms_page_id, template_variable, is_list) VALUES (?, ?, ?)",
                    params: [model.cms_page_id!, variable, isList]
                )

                if resultsContent.error == false {

                    let cmsPageContentId = Int(resultsContent.insertId!)

                    for content in contentArray {

                        if content["type"] == "markdown" {

                            let resultsContentMarkdown = insert(
                                statement: "INSERT INTO cms_page_content_link_markdown (cms_page_content_id, cms_markdown_id) VALUES (?, (SELECT cms_markdown_id FROM cms_markdown WHERE handle = ?))",
                                params: [cmsPageContentId, content["handle"]!]
                            )

                            if resultsContentMarkdown.error == true {
                                print("Insert error")
                                //FIXME / TODO - Rollback
                            }

                        } else if content["type"] == "words" {

                            let resultsContentWords = insert(
                                statement: "INSERT INTO cms_page_content_link_words (cms_page_content_id, cms_words_id) VALUES (?, (SELECT cms_words_id FROM cms_words WHERE handle = ?))",
                                params: [cmsPageContentId, content["handle"]!]
                            )

                            if resultsContentWords.error == true {
                                print("Insert error")
                                //FIXME / TODO - Rollback
                            }

                        }

                    }

                }

            } // End insert vars

            do {

                let pageWithVars = try self.getByPath(path: model.uri!)

                if pageWithVars != nil {
                    return pageWithVars!
                }

            } catch {
                //TODO / FIXME
            }

        } else {
            model.errors["create"] = results.errorMessage
        }

        return model

    }

}