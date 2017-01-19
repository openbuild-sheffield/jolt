import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

private struct RepositoryCMSMarkdownCache {

    private static var cache: [String: ModelCMSMarkdown] = [:]

    static func get(key: String) -> ModelCMSMarkdown? {

        if let model = self.cache[key] {
            return model
        } else {
            return nil
        }

    }

    static func set(key: String, value: ModelCMSMarkdown) {
        self.cache[key] = value
    }

    static func delete(key: String) {
        self.cache.removeValue(forKey: key)
    }

}

public class RepositoryCMSMarkdown: OpenbuildMysql.OBMySQL {

    public init() throws {

        guard let connectionDetails = OpenbuildSingleton.Manager.getConnectionDetails(
            module: "cms",
            name: "cms",
            type: "mysql"
        )else{
            throw RepoError.connection(
                messagePublic: "Connection details not found for RouteCMS:CMSMarkdown",
                messageDev: "Connection details not found for RouteCMS:CMSMarkdown auth:role:mysql"
            )
        }

        try super.init(
                connectionParams: connectionDetails.connectionParams as! MySQLConnectionParams,
                database: connectionDetails.connectionDetails.db
        )

    }

    public func install() throws -> Bool {

        let installed = try super.tableExists(table: "cms_markdown")

        if installed == false {

            print("installed: \(installed)")

            let installSQL = String(current: #file, path: "SQL/cms_markdown.sql")

            print("DOING CREATE TABLE:")
            print(installSQL!)

            let created = try super.tableCreate(statement: installSQL!)

            print("created: \(created)")

            let insertSQL = String(current: #file, path: "SQL/cms_markdown_insert.sql")

            print("INSERT DATA:")
            print(insertSQL!)

            let results = insert(
                statement: insertSQL!
            )

            print(results)

        } else {

            print("installed: \(installed)")

        }

        //TODO - upgrades

        return true

    }

    public func create(model: ModelCMSMarkdown) -> ModelCMSMarkdown {

        let results = insert(
            statement: "INSERT INTO cms_markdown (handle, markdown, html) VALUES (?, ?, ?)",
            params: [model.handle!, model.markdown!, model.html!]
        )

        if results.error == false && results.affectedRows == 1{
            model.cms_markdown_id = Int(results.insertId!)
        } else {
            model.errors["create"] = results.errorMessage
        }

        return model

    }

    public func getByHandle(handle: String) throws -> ModelCMSMarkdown? {

        if let cachedModel = RepositoryCMSMarkdownCache.get(key: handle) {
            return cachedModel
        }

        let results = try select(
            statement: "SELECT * FROM cms_markdown WHERE handle = ?",
            params: [handle]
        )

        if(results.count == 1){

            let model = ModelCMSMarkdown(dictionary: results[0])
            RepositoryCMSMarkdownCache.set(key: handle, value: model)
            return model

        }

        return nil

    }

    public func delete(model: ModelCMSMarkdown) -> ModelCMSMarkdown {

        //FIXME / TODO - Transactions

        let cmsDelete = delete(
            statement: "DELETE FROM cms_markdown WHERE cms_markdown_id = ?",
            params: [model.cms_markdown_id!]
        )

        if cmsDelete.error {
            model.errors["delete"] = cmsDelete.errorMessage!
        } else if cmsDelete.affectedRows! != 1 {
            model.errors["num_rows"] = "Failed to delete correct number of rows \(cmsDelete.affectedRows!)"
        }

        RepositoryCMSMarkdownCache.delete(key: model.handle!)

        return model

    }

    public func update(model: ModelCMSMarkdown) -> ModelCMSMarkdown {

        let results = update(
            statement: "UPDATE cms_markdown SET markdown = ?, html = ? WHERE cms_markdown_id = ?",
            params: [model.markdown!, model.html!, model.cms_markdown_id!]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows != 1 {
            model.errors["num_rows"] = "Failed to update correct number of rows \(results.affectedRows!)"
        } else if results.error {
            model.errors["update"] = results.errorMessage
        } else {
            RepositoryCMSMarkdownCache.set(key: model.handle!, value: model)
        }

        return model

    }

}