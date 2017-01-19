import OpenbuildMysql
import OpenbuildRepository
import OpenbuildSingleton

public class RepositoryAuth: OpenbuildMysql.OBMySQL {

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

        let security = OpenbuildSingleton.Manager.getSecurity()

        let installedToken = try super.tableExists(table: "token")

        if installedToken == false {

            print("installedToken: \(installedToken)")

            let installTokenSQL = String(current: #file, path: "SQL/token.sql")

            print("DOING CREATE TABLE:")
            print(installTokenSQL!)

            let createdToken = try super.tableCreate(statement: installTokenSQL!)

            print("created table token: \(createdToken)")

        } else {

            print("table token exists: \(installedToken)")

        }

        let installedUser = try super.tableExists(table: "user")

        if installedUser == false {

            print("installedUser: \(installedUser)")

            let installUserSQL = String(current: #file, path: "SQL/user.sql")

            print("DOING CREATE TABLE:")
            print(installUserSQL!)

            let createdUser = try super.tableCreate(statement: installUserSQL!)

            print("createdUser: \(createdUser)")

            let insertUserSQL = String(current: #file, path: "SQL/userInsert.sql")

            print("INSERT DATA:")
            print(insertUserSQL!)

            let secret = security.randomString()
            let email = security.encrypt(toEncrypt: "admin@test.com")!
            let password = security.hash(salt: secret, contents: "letmein")

            let insertUserResults = self.insert(
                statement: insertUserSQL!,
                params: [secret, email, password]
            )

            print(insertUserResults)


        } else {

            print("table user exists: \(installedUser)")

        }

        //TODO - upgrades

        return true

    }

    public func getByUsernameEmailPassword(username: String, email: String, password: String) throws -> ModelUserPlain? {

        let security = OpenbuildSingleton.Manager.getSecurity()

        let encryptedEmail = security.encrypt(toEncrypt: email)!

        var results = try select(
            statement: "SELECT * FROM user WHERE username = ? AND email = ?",
            params: [username, encryptedEmail]
        )

        if(results.count == 1){

            var userDict = results[0]

            let passwordMatch = security.hashMatch(
                salt: userDict["secret"]! as! String,
                contents: password,
                hash: userDict["password"]! as! String
            )

            if passwordMatch {

                userDict["email"] = email

                let passwordUpdate = userDict["passwordUpdate"]! as! Int8

                if passwordUpdate == 1 {
                    userDict["passwordUpdate"] = Optional(true)
                } else {
                    userDict["passwordUpdate"] = Optional(false)
                }

                let roles = try select(
                    statement: "SELECT role.role_id, role.role FROM role INNER JOIN userLinkRole ON role.role_id = userLinkRole.role_id INNER JOIN user ON userLinkRole.user_id = user.user_id WHERE user.user_id = ?",
                    params: [userDict["user_id"]!]
                )

                userDict["roles"] = roles

                return ModelUserPlain(dictionary: userDict)

            }

        }

        return nil

    }

    public func updatePassword(model: ModelUserPlain) -> ModelUserPlain{

        let results = update(
            statement: "UPDATE user SET password = ? WHERE user_id = ?",
            params: [model.password, model.user_id!]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows != 1 {

            model.errors["num_rows"] = "Failed to update correct number of rows \(results.affectedRows!)"

        } else if results.error {

            model.errors["update"] = results.errorMessage

        } else {

            _ = update(
                statement: "UPDATE user SET passwordUpdate = 0 WHERE user_id = ?",
                params: [model.user_id!]
            )

            model.passwordUpdate = false

        }

        return model

    }

    public func updateEmail(model: ModelUserPlain) -> ModelUserPlain{

        let results = update(
            statement: "UPDATE user SET email = ? WHERE user_id = ?",
            params: [model.email, model.user_id!]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows != 1 {

            model.errors["num_rows"] = "Failed to update correct number of rows \(results.affectedRows!)"

        } else if results.error {

            model.errors["update"] = results.errorMessage

        }

        return model

    }

    public func createToken(model: ModelUserPlain) -> String? {

        do {

            let encoded = try model.jsonEncodedString()

            let security = OpenbuildSingleton.Manager.getSecurity()

            let secret = security.randomString()
            //let claims = ["fu" : "bar", "bob" : "baz"]
            let claims = security.getDefaultClaims()
            let audience = security.getDefaultAudience()

            //guard let token = security.JWTEncode(secret: secret, audience: "testAudience", claims: claims, data: ["user": encoded]) else {
            guard let token = security.JWTEncode(secret: secret, audience: audience, claims: claims, data: ["user": encoded]) else {
                print("Failed to generate JWT token")
                return nil
            }

            let results = insert(
                statement: "INSERT INTO token (token, secret) VALUES (?, ?)",
                params: [token, secret]
            )

            _ = delete(
                statement: "DELETE FROM token WHERE created < DATE_SUB(NOW(), INTERVAL ? SECOND)",
                params: [security.getTimeout()]
            )

            if results.error == false && results.affectedRows == 1{
                return token
            } else {
                return nil
            }

        } catch {
            return nil
        }

    }

    public func deleteToken(token: String) -> Bool? {

        let results = delete(
            statement: "DELETE FROM token WHERE token = ?",
            params: [token]
        )

        //FIXME TODO TRANSACTIONS
        if results.error == false && results.affectedRows == 1 {

            return true

        } else if results.error {

            print(results)
            return nil

        } else {

            return false

        }

    }

}