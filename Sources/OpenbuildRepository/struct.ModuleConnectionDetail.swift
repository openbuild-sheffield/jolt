public struct ModuleConnectionDetail {

    public var type: String
    public var namedConnection: String
    public var db: String

    public init(type: String, namedConnection: String, db: String){
        self.type = type
        self.namedConnection = namedConnection
        self.db = db
    }

}