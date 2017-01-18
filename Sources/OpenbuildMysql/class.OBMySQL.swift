import MySQL
import OpenbuildExtensionCore
import OpenbuildRepository
import Foundation

open class OBMySQL {

    public var connectionParams: MySQLConnectionParams
    public var database: String

    public init(connectionParams: MySQLConnectionParams, database: String) throws {

        self.connectionParams = connectionParams
        self.database = database

    }

    public func tableExists(table: String) throws -> Bool {

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.connect(message: mysql.errorMessage())
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        let statement = "DESC " + table

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.statementPrepareFailed(message: mysql.errorMessage())
        }

        let executed = mysqlStatement.execute()

        guard executed else {

            let message = mysql.errorMessage()

            if message.contains("doesn't exist") {
                return false
            }

            print("Failed to execute statement:");
            print(message)
            throw OpenbuildRepository.RepoError.statementExecuteFailed(message: mysql.errorMessage())
        }

        return true

    }

    public func tableCreate (statement: String) throws -> Bool {

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.connect(message: mysql.errorMessage())
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.statementPrepareFailed(message: mysql.errorMessage())
        }

        let executed = mysqlStatement.execute()

        guard executed else {

            let message = mysql.errorMessage()

            print("Failed to execute statement:");
            print(message)
            throw OpenbuildRepository.RepoError.statementExecuteFailed(message: mysql.errorMessage())
        }

        return true

    }

    public func select(statement: String, params: [Any]?=nil) throws -> [[String:Any]] {

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.connect(message: mysql.errorMessage())
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        mysqlStatement.reset()

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.statementPrepareFailed(message: mysql.errorMessage())
        }

        if let p = params {
            p.flatMap{$0}.map {
                //Int(dictionary["user_id"]! as! UInt32)
                switch $0 {
                case is Double:
                    mysqlStatement.bindParam($0 as! Double)
                case is Int:
                    mysqlStatement.bindParam($0 as! Int)
                case is UInt32:
                    mysqlStatement.bindParam(Int($0 as! UInt32))
                case is UInt64:
                    mysqlStatement.bindParam($0 as! UInt64)
                case is String:
                    mysqlStatement.bindParam($0 as! String)
                default:
                    mysqlStatement.bindParam()
                }
            }
        }

        let executed = mysqlStatement.execute()

        guard executed else {
            print("Failed to execute statement:");
            print(mysql.errorMessage())
            throw OpenbuildRepository.RepoError.statementExecuteFailed(message: mysql.errorMessage())
        }

        let results = mysqlStatement.results()

        let fieldNames = mysqlStatement.fieldNames()

        var arrayResults: [[String:Any]] = []

        results.forEachRow { row in

            var rowDictionary = [String: Any]()

            var i = 0

            while i != results.numFields {

                //FIXME - HACK BECAUSE OF MySQL Client
                var item = row[i]!

                if item is Array<UInt8> {
                    item = String(utf8Bytes: item as! [UInt8] ) as Any
                }
                //END FIXME - HACK BECAUSE OF MySQL Client

                rowDictionary[fieldNames[i]!] = item
                i += 1
            }

            arrayResults.append(rowDictionary)

        }

        return arrayResults

    }

    public func insert(statement: String, params: [Any]?=nil) -> MySQLInsert {

        var results = MySQLInsert()

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        if let p = params {
            p.flatMap{$0}.map {
                //mysqlStatement.bindParam($0)
                switch $0 {
                case is Double:
                    mysqlStatement.bindParam($0 as! Double)
                case is Int:
                    mysqlStatement.bindParam($0 as! Int)
                case is UInt64:
                    mysqlStatement.bindParam($0 as! UInt64)
                case is String:
                    mysqlStatement.bindParam($0 as! String)
                default:
                    mysqlStatement.bindParam()
                }
            }
        }

        let executed = mysqlStatement.execute()

        guard executed else {
            print("Failed to execute statement:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        results.affectedRows = mysqlStatement.affectedRows()
        results.insertId = mysqlStatement.insertId()

        return results

    }

    public func delete(statement: String, params: [Any]?=nil) -> MySQLDelete {

        var results = MySQLDelete()

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        if let p = params {
            p.flatMap{$0}.map {
                //mysqlStatement.bindParam($0)
                switch $0 {
                case is Double:
                    mysqlStatement.bindParam($0 as! Double)
                case is Int:
                    mysqlStatement.bindParam($0 as! Int)
                case is UInt64:
                    mysqlStatement.bindParam($0 as! UInt64)
                case is String:
                    mysqlStatement.bindParam($0 as! String)
                default:
                    mysqlStatement.bindParam()
                }
            }
        }

        let executed = mysqlStatement.execute()

        guard executed else {
            print("Failed to execute statement:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        results.affectedRows = mysqlStatement.affectedRows()

        return results

    }

    public func update(statement: String, params: [Any]?=nil) -> MySQLUpdate {

        var results = MySQLUpdate()

        // Create an instance of MySQL to work with
        let mysql = MySQL()

        let connected = mysql.connect(
            host: self.connectionParams.host,
            user: self.connectionParams.username,
            password: self.connectionParams.password,
            db: self.database
        )

        guard connected else {
            // verify we connected successfully
            print("Failed to connect");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        defer {
            //This defer block makes sure we terminate the connection once finished,
            //regardless of the result
            mysql.close()
        }

        let mysqlStatement = MySQLStmt(mysql)

        let queryPrepare = mysqlStatement.prepare(statement: statement)

        guard queryPrepare else {
            print("Failed to prepare query:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        if let p = params {
            p.flatMap{$0}.map {
                //mysqlStatement.bindParam($0)
                switch $0 {
                case is Double:
                    mysqlStatement.bindParam($0 as! Double)
                case is Int:
                    mysqlStatement.bindParam($0 as! Int)
                case is UInt64:
                    mysqlStatement.bindParam($0 as! UInt64)
                case is String:
                    mysqlStatement.bindParam($0 as! String)
                default:
                    mysqlStatement.bindParam()
                }
            }
        }

        let executed = mysqlStatement.execute()

        guard executed else {
            print("Failed to execute statement:");
            print(mysql.errorMessage())
            results.setErrorMessage(message: mysql.errorMessage())
            return results
        }

        results.affectedRows = mysqlStatement.affectedRows()

        return results

    }

}