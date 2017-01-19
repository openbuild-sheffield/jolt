import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

public class RepositoryUserLinkRole: OpenbuildMysql.OBMySQL {

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

        let installed = try super.tableExists(table: "userLinkRole")

        if installed == false {

            print("installed: \(installed)")

            let installSQL = String(current: #file, path: "SQL/userLinkRole.sql")

            print("DOING CREATE TABLE:")
            print(installSQL!)

            let created = try super.tableCreate(statement: installSQL!)

            print("created: \(created)")

            let insertSQL = String(current: #file, path: "SQL/userLinkRoleInsert.sql")

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

    public func addRole(user: ModelUserPlainMin, role: ModelRole) -> ModelRole{

        let results = insert(
            statement: "INSERT INTO userLinkRole (user_id, role_id) VALUES (?, ?)",
            params: [user.user_id!, role.role_id!]
        )

        if results.error == true {
            role.errors["insert"] = results.errorMessage
        } else if results.affectedRows! != 1 {
            role.errors["insert"] = "Failed to insert."
        }

        return role

    }

    public func deleteRole(user: ModelUserPlainMin, role: ModelRole) -> ModelRole{

        let results = insert(
            statement: "DELETE FROM userLinkRole WHERE user_id = ? AND role_id = ?",
            params: [user.user_id!, role.role_id!]
        )

        if results.error == true {
            role.errors["delete"] = results.errorMessage
        } else if results.affectedRows! != 1 {
            role.errors["delete"] = "Failed to insert."
        }

        return role

    }

}