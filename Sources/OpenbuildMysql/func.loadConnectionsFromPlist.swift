import Foundation
import PerfectLib

public func loadConnectionsFromPlist(path: String) -> [String: MySQLConnectionParams]{

    var connectionParams: [String: MySQLConnectionParams] = [:]

    print("READING MySQL Connections from file: \(path)")

    do {

        let configURL = URL(fileURLWithPath: path)
        let configData = try Data(contentsOf:configURL)
        let configDictionary = try PropertyListSerialization.propertyList(from: configData, options: [], format: nil) as! [String:Any]
        let dataConnectionsDictionary = configDictionary["dataConnections"] as! [String: [[String: Any]]]

        if let mysqlConnections = dataConnectionsDictionary["mysql"] {

            for mysqlConnection in mysqlConnections {

                guard let name = mysqlConnection["name"] else {
                    print("No mysql name: ");
                    print(mysqlConnection);
                    exit(0)
                }

                guard let host = mysqlConnection["host"] else {
                    print("No mysql host: ");
                    print(mysqlConnection);
                    exit(0)
                }

                guard let username = mysqlConnection["username"] else {
                    print("No mysql username: ");
                    print(mysqlConnection);
                    exit(0)
                }

                guard let password = mysqlConnection["password"] else {
                    print("No mysql password: ");
                    print(mysqlConnection);
                    exit(0)
                }

                connectionParams[name as! String] = MySQLConnectionParams(
                    host: host as! String,
                    username: username as! String,
                    password: password as! String
                )

            }

        }

        return connectionParams

    } catch {
        print("Failed to load config file")
        exit(0)
    }

}