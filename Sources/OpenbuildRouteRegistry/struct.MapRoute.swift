import OpenbuildExtensionPerfect
import PerfectHTTP
import PerfectLib

public struct MapRoute {

    public var method: HTTPMethod
    public var uri: String

    public init(
        method: HTTPMethod,
        uri: String
    ){
        self.method = method
        self.uri = uri
    }

}