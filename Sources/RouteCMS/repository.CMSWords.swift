import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

private struct RepositoryCMSWordsCache {

    private static var cache: [String: ModelCMSWords] = [:]

    static func get(key: String) -> ModelCMSWords? {

        if let model = self.cache[key] {
            return model
        } else {
            return nil
        }

    }

    static func set(key: String, value: ModelCMSWords) {
        self.cache[key] = value
    }

    static func delete(key: String) {
        self.cache.removeValue(forKey: key)
    }

}

public class RepositoryCMSWords: OpenbuildMysql.OBMySQL {

    public init() throws {

        guard let connectionDetails = OpenbuildSingleton.Manager.getConnectionDetails(
            module: "cms",
            name: "cms",
            type: "mysql"
        )else{
            throw RepoError.connection(
                messagePublic: "Connection details not found for RouteCMS:CMSWords",
                messageDev: "Connection details not found for RouteCMS:CMSWords auth:role:mysql"
            )
        }

        try super.init(
                connectionParams: connectionDetails.connectionParams as! MySQLConnectionParams,
                database: connectionDetails.connectionDetails.db
        )

    }

    public func install() throws -> Bool {

        let installed = try super.tableExists(table: "cms_words")

        if installed == false {

            print("installed: \(installed)")

            let installSQL = String(current: #file, path: "SQL/cms_words.sql")

            print("DOING CREATE TABLE:")
            print(installSQL!)

            let created = try super.tableCreate(statement: installSQL!)

            print("created: \(created)")

/*
            let insertSQL = String(current: #file, path: "SQL/roleInsert.sql")

            print("INSERT DATA:")
            print(insertSQL!)

            let results = insert(
                statement: insertSQL!
            )

            print(results)
*/
        } else {

            print("installed: \(installed)")

        }

        //TODO - upgrades

        return true

    }

    public func create(model: ModelCMSWords) -> ModelCMSWords {

        let results = insert(
            statement: "INSERT INTO cms_words (handle, words) VALUES (?, ?)",
            params: [model.handle!, model.words!]
        )

        if results.error == false && results.affectedRows == 1{
            model.cms_words_id = Int(results.insertId!)
        } else {
            model.errors["create"] = results.errorMessage
        }

        return model

    }

    public func getByHandle(handle: String) throws -> ModelCMSWords? {

        if let cachedModel = RepositoryCMSWordsCache.get(key: handle) {
            return cachedModel
        }

        let results = try select(
            statement: "SELECT * FROM cms_words WHERE handle = ?",
            params: [handle]
        )

        if(results.count == 1){

            let model = ModelCMSWords(dictionary: results[0])
            RepositoryCMSWordsCache.set(key: handle, value: model)
            return model

        }

        return nil

    }

    public func delete(model: ModelCMSWords) -> ModelCMSWords {

        //FIXME / TODO - Transactions

        let cmsDelete = delete(
            statement: "DELETE FROM cms_words WHERE cms_words_id = ?",
            params: [model.cms_words_id!]
        )

        if cmsDelete.error {
            model.errors["delete"] = cmsDelete.errorMessage!
        } else if cmsDelete.affectedRows! != 1 {
            model.errors["num_rows"] = "Failed to delete correct number of rows \(cmsDelete.affectedRows!)"
        }

        RepositoryCMSWordsCache.delete(key: model.handle!)

        return model

    }

    public func update(model: ModelCMSWords) -> ModelCMSWords {

        let results = update(
            statement: "UPDATE cms_words SET words = ? WHERE cms_words_id = ?",
            params: [model.words!, model.cms_words_id!]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows != 1 {
            model.errors["num_rows"] = "Failed to update correct number of rows \(results.affectedRows!)"
        } else if results.error {
            model.errors["update"] = results.errorMessage
        } else {
            RepositoryCMSWordsCache.set(key: model.handle!, value: model)
        }

        return model

    }

}