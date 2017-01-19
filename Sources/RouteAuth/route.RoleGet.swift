import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestRoleGet: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Get a role by id."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateUriRoleId
        ])

    }

}

public let handlerRouteRoleGet = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryRole()

        let role = try repository.getById(
            id: request.validatedRequestData?.validated["role_id"] as! Int
        )

        if role == nil {

            handlerResponse.complete(
                status: 404,
                model: ResponseModel404(uri: request.uri, method: request.method.description)
            )

        } else {

            //Success
            handlerResponse.complete(
                status: 200,
                model: ModelRole200Entity(entity: role!)
            )

        }

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

public class RouteRoleGet: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelRole200Entity")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 404)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestRoleGet(
                method: "get",
                uri: "/api/roles/{role_id}"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteRoleGet
        )

    }

}