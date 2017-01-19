import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestRolesGet: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Get all roles."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            //ValidateTokenUsername,
            ValidateTokenRoles
        ])

    }

}

public let handlerRouteRolesGet = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryRole()

        let allRoles = try repository.all()

        //Success
        handlerResponse.complete(
            status: 200,
            model: ModelRole200Entities(entities: allRoles!)
        )


    } catch {

        print(error)

        handlerResponse.complete(
            status: 500,
            model: ResponseModel500Messages(messages: [
                "message": "Failed to generate a successful response."
            ])
        )

    }

}

public class RouteRolesGet: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelRole200Entities")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestRolesGet(
                method: "get",
                uri: "/api/roles"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteRolesGet
        )

    }

}