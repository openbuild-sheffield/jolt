import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestRoleUpdate: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Update a role by id."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateUriRoleId,
            ValidateBodyRole
        ])

    }

}

public let handlerRouteRoleUpdate = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryRole()

        var model = ModelRole(
            role_id: request.validatedRequestData?.validated["role_id"] as! Int,
            role: request.validatedRequestData?.validated["role"] as! String
        )

        guard let oldRole = try repository.getById(
            id: request.validatedRequestData?.validated["role_id"] as! Int
        ) else {

            handlerResponse.complete(
                status: 404,
                model: ResponseModel404(uri: request.uri, method: request.method.description)
            )

            return

        }

        let updatedRole = repository.update(
            model: model
        )

        if updatedRole.errors.isEmpty {

            handlerResponse.complete(
                status: 200,
                model: ModelRole200Update(old: oldRole, updated: updatedRole)
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "updated": false,
                        "errors": updatedRole.errors,
                        "entities": ["old": oldRole, "attempted": updatedRole]
                    ]
                )
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

public class RouteRoleUpdate: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelRole200Update")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 404)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestRoleUpdate(
                method: "put",
                uri: "/api/roles/{role_id}"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteRoleUpdate
        )

    }

}