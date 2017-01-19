import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

public class RepositoryRole: OpenbuildMysql.OBMySQL {

    public init() throws {

        guard let connectionDetails = OpenbuildSingleton.Manager.getConnectionDetails(
            module: "auth",
            name: "role",
            type: "mysql"
        )else{
            throw RepoError.connection(
                messagePublic: "Connection details not found for RouteAuth:Auth",
                messageDev: "Connection details not found for RouteAuth:Auth auth:role:mysql"
            )
        }

        try super.init(
                connectionParams: connectionDetails.connectionParams as! MySQLConnectionParams,
                database: connectionDetails.connectionDetails.db
        )

    }

    public func install() throws -> Bool {

        let installed = try super.tableExists(table: "role")

        if installed == false {

            print("installed: \(installed)")

            let installSQL = String(current: #file, path: "SQL/role.sql")

            print("DOING CREATE TABLE:")
            print(installSQL!)

            let created = try super.tableCreate(statement: installSQL!)

            print("created: \(created)")

            let insertSQL = String(current: #file, path: "SQL/roleInsert.sql")

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

    public func all() throws -> ModelRoles? {

        let results = try select(statement: "SELECT * FROM role ORDER BY role_id")

        if(results.count >= 1){
            let roles = ModelRoles(roles: results)
            return roles
        }

        return nil

    }

    public func getById(id: Int) throws -> ModelRole? {

        let results = try select(
            statement: "SELECT * FROM role WHERE role_id = ?",
            params: [id]
        )

        if(results.count == 1){
            let role = ModelRole(dictionary: results[0])
            return role
        }

        return nil

    }

    public func getByRole(role: String) throws -> ModelRole? {

        let results = try select(
            statement: "SELECT * FROM role WHERE role = ?",
            params: [role]
        )

        if(results.count == 1){
            let role = ModelRole(dictionary: results[0])
            return role
        }

        return nil

    }

    public func create(model: ModelRole) -> ModelRole {

        let results = insert(
            statement: "INSERT INTO role (role) VALUES (?)",
            params: [model.role!]
        )

        if results.error == false && results.affectedRows == 1{
            model.role_id = Int(results.insertId!)
        } else {
            model.errors["create"] = results.errorMessage
        }

        return model

    }

    public func delete(model: ModelRole) -> ModelRole {

        //FIXME / TODO - Transactions

        let deleteUserLinkRole = delete(
            statement: "DELETE FROM userLinkRole WHERE role_id = ?",
            params: [model.role_id!]
        )

        if deleteUserLinkRole.error == false {

            let userDelete = delete(
                statement: "DELETE FROM role WHERE role_id = ?",
                params: [model.role_id!]
            )

            if userDelete.error {

                model.errors["delete"] = userDelete.errorMessage!

            } else if userDelete.affectedRows! != 1 {

                model.errors["num_rows"] = "Failed to delete correct number of rows \(userDelete.affectedRows!)"

            }

        } else {

            model.errors["links"] = deleteUserLinkRole.errorMessage!

        }

        return model

    }

    public func update(model: ModelRole) -> ModelRole {

        let results = update(
            statement: "UPDATE role SET role = ? WHERE role_id = ?",
            params: [model.role!, model.role_id!]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows != 1 {
            model.errors["num_rows"] = "Failed to update correct number of rows \(results.affectedRows!)"
        } else if results.error {
            model.errors["update"] = results.errorMessage
        }

        return model

    }

}