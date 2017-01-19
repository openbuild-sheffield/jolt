import PerfectLib
import PerfectHTTP
import OpenbuildExtensionPerfect

public struct NamedRoute {

    public var method: String
    public var uri: String
    public var handlerRequest: RequestProtocol?
    public var handlerResponse: ResponseDefined?
    public var handlerRoute: RequestHandler

    public init(
        method: String,
        uri: String,
        handlerRoute: @escaping RequestHandler
    ){
        self.method = method
        self.uri = uri
        self.handlerRoute = handlerRoute
    }

    public init(
        handlerRequest: RequestProtocol,
        handlerRoute: @escaping RequestHandler
    ){
        self.method = handlerRequest.method
        self.uri = handlerRequest.uri
        self.handlerRequest = handlerRequest
        self.handlerRoute = handlerRoute
    }

    public init(
        handlerRequest: RequestProtocol,
        handlerResponse: ResponseDefined,
        handlerRoute: @escaping RequestHandler
    ){
        self.method = handlerRequest.method
        self.uri = handlerRequest.uri
        self.handlerRequest = handlerRequest
        self.handlerResponse = handlerResponse
        self.handlerRoute = handlerRoute
    }

}