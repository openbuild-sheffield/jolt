import Foundation
import PerfectLib

public func loadConnectionsFromPlist(path: String) -> [String: ModuleConnectionDetail]{

    var moduleConnectionDetails: [String: ModuleConnectionDetail] = [:]

    print("READING module connection details from file: \(path)")

    do {

        let configURL = URL(fileURLWithPath: path)
        let configData = try Data(contentsOf:configURL)
        let configDictionary = try PropertyListSerialization.propertyList(from: configData, options: [], format: nil) as! [String:Any]
        let dataConnectionsDictionary = configDictionary["dataConnections"] as! [String: [[String: Any]]]

        for (type, connections) in dataConnectionsDictionary {

            for connection in connections {

                guard let namedConnection = connection["name"] else {
                    print("No name for connection: ");
                    print(connection);
                    exit(0)
                }

                guard let stores = connection["stores"] else {
                    print("No stores for connection: ");
                    print(connection);
                    exit(0)
                }

                for store in stores as! [[String: String]]{

                    guard let db = store["db"] else {
                        print("No db in store \(connection) : \(store)")
                        exit(0)
                    }

                    guard let name = store["name"] else {
                        print("No name in store \(connection) : \(store)")
                        exit(0)
                    }

                    let key = type + (namedConnection as! String) + name

                    moduleConnectionDetails[key] = ModuleConnectionDetail(
                        type: type,
                        namedConnection: namedConnection as! String,
                        db: db
                    )

                }

            }

        }

    } catch {

        print("Failed to load config file")
        exit(0)

    }

    return moduleConnectionDetails

}