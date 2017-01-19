import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

public class Auth: OpenbuildMysql.OBMySQL {

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

    public func getSecret(token: String) throws -> ModelToken? {

        let results = try select(
            statement: "SELECT * FROM token WHERE token = ?",
            params: [token]
        )

        if(results.count == 1){

            return ModelToken(
                dictionary: [
                    "token": results[0]["token"]! as! String,
                    "secret": results[0]["secret"]! as! String
                ]
            )

        }

        return nil

    }

}