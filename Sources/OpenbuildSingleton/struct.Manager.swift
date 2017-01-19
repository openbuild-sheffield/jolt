import PerfectLib
import PerfectHTTP
import OpenbuildMysql
import OpenbuildRepository

public struct Manager {

    private static var themePath: String?
    private static var path: String?
    private static var security: Security?
    private static var mysqlConnectionParams: [String: OpenbuildMysql.MySQLConnectionParams] = [:]
    private static var moduleConnectionDetails: [String: OpenbuildRepository.ModuleConnectionDetail] = [:]
    private static var dataConnectionMap: [String: [String:String]] = [:]

    public static func setThemePath(path: String) {
        if self.themePath == nil {
            self.themePath = path
        }
    }

    public static func getThemePath() -> String {
        return self.themePath!
    }

    public static func setPath(path: String) {
        if self.path == nil {
            self.path = path
        }
    }

    public static func getPath() -> String{

        if self.path == nil {
            self.path = "./config.plist"
        }

        return self.path!

    }

    public static func getSecurity() -> Security {

        if self.security != nil {
            return self.security!
        } else {
            print("Setting up security instance")
            self.security = Security(path: self.getPath())
            return self.security!
        }

    }

    public static func getMySQLConnections() -> [String: OpenbuildMysql.MySQLConnectionParams]{

        if self.mysqlConnectionParams.isEmpty {

            print("Setting up MySQL Connections instance")
            self.mysqlConnectionParams = OpenbuildMysql.loadConnectionsFromPlist(path: self.getPath())

        }

        return self.mysqlConnectionParams

    }

    public static func getMySQLConnection(name: String) -> MySQLConnectionParams?{

        return self.getMySQLConnections()[name]

    }

    public static func getModuleConnectionDetails() -> [String: OpenbuildRepository.ModuleConnectionDetail]{

        if self.moduleConnectionDetails.isEmpty {

            print("Setting up module connection details instance")
            self.moduleConnectionDetails = OpenbuildRepository.loadConnectionsFromPlist(path: self.getPath())

        }

        return self.moduleConnectionDetails

    }

    public static func getModuleConnectionDetail(name: String) -> OpenbuildRepository.ModuleConnectionDetail?{

        return self.getModuleConnectionDetails()[name]

    }

    public static func addDataConnectionMap(module: String, connection: String, type: String) {
        self.dataConnectionMap[module] = ["connection": connection, "type": type]
    }

    public static func getDataConnectionMap(_ module: String) -> [String:String]? {
        return dataConnectionMap[module]
    }

    public static func getConnectionDetails(module: String, name: String, type: String) -> RepositoryConnectionParams? {

        guard let connectionMap = OpenbuildSingleton.Manager.getDataConnectionMap(module) else {
            return nil
        }

        let key = connectionMap["type"]! + connectionMap["connection"]! + name

        guard let connectionDetails = OpenbuildSingleton.Manager.getModuleConnectionDetail(name: key) else {
            return nil
        }

        if type == "mysql" {

            guard let connectionParams = OpenbuildSingleton.Manager.getMySQLConnection(name: connectionDetails.namedConnection) else {
                return nil
            }

            return RepositoryConnectionParams(connectionDetails: connectionDetails, connectionParams: connectionParams)

        } else {
            return nil
        }

    }

}