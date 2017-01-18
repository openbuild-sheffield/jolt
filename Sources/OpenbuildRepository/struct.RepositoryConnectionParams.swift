public struct RepositoryConnectionParams {

    public var connectionDetails: ModuleConnectionDetail
    public var connectionParams: Any

    public init(connectionDetails: ModuleConnectionDetail, connectionParams: Any){
        self.connectionDetails = connectionDetails
        self.connectionParams = connectionParams
    }

}