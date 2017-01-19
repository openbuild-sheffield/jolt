import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

public class RepositoryUser: OpenbuildMysql.OBMySQL {

    public init() throws {

        guard let connectionDetails = OpenbuildSingleton.Manager.getConnectionDetails(
            module: "auth",
            name: "role",
            type: "mysql"
        )else{
            throw RepoError.connection(
                messagePublic: "Connection details not found for RouteAuth:User",
                messageDev: "Connection details not found for RouteAuth:User auth:role:mysql"
            )
        }

        try super.init(
                connectionParams: connectionDetails.connectionParams as! MySQLConnectionParams,
                database: connectionDetails.connectionDetails.db
        )

    }

    public func all() throws -> ModelUsersPlainMin? {

        var results = try select(statement: "SELECT * FROM user ORDER BY username")

        if(results.count >= 1){

            for (index, user) in results.enumerated() {

                results[index]["roles"] = try select(
                    statement: "SELECT role.role_id, role.role FROM role INNER JOIN userLinkRole ON role.role_id = userLinkRole.role_id INNER JOIN user ON userLinkRole.user_id = user.user_id WHERE user.user_id = ?",
                    params: [user["user_id"]!]
                )

            }

            let roles = ModelUsersPlainMin(users: results)
            return roles

        }

        return nil

    }

    public func create(model: ModelUserCreate) -> ModelUserCreate {

        let results = insert(
            statement: "INSERT INTO user (username, secret, email, password) VALUES (?, ?, ?, ?)",
            params: [
                model.username,
                model.secret,
                model.email,
                model.password
            ]
        )

        if results.error{
            model.errors["create"] = results.errorMessage
        } else if results.affectedRows != 1{
            model.errors["create"] = "Invalid number of rows"
        }

        return model

    }

    public func getByUsername(username: String) throws -> ModelUserPlainMin? {

        let results = try select(
            statement: "SELECT * FROM user WHERE username = ?",
            params: [username]
        )

        if(results.count == 1){

            var user = results[0]

            user["roles"] = try select(
                statement: "SELECT role.role_id, role.role FROM role INNER JOIN userLinkRole ON role.role_id = userLinkRole.role_id INNER JOIN user ON userLinkRole.user_id = user.user_id WHERE user.user_id = ?",
                params: [user["user_id"]!]
            )

            return ModelUserPlainMin(dictionary: user)

        }

        return nil

    }

}