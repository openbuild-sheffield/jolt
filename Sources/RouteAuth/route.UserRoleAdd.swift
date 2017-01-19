import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestUserRoleAdd: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Adds a role to a user."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateUriUsername,
            ValidateBodyRole
        ])

    }

}

public let handlerRouteUserRoleAdd = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repositoryUser = try RepositoryUser()
        var repositoryRole = try RepositoryRole()

        let user = try repositoryUser.getByUsername(
            username: request.validatedRequestData?.validated["username"] as! String
        )

        let role = try repositoryRole.getByRole(
            role: request.validatedRequestData?.validated["role"] as! String
        )

        if user == nil || role == nil {

            var messages: [String:Any] = ["added_role": false]

            if user == nil {
                messages["user"] = ["error": true, "message": "Not found"]
            }

            if role == nil {
                messages["role"] = ["error": true, "message": "Not found"]
            }

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: messages
                )
            )

        } else {

            let repositoryUserLinkRole = try RepositoryUserLinkRole()

            let addedRole = repositoryUserLinkRole.addRole(user: user!, role: role!)

            //Success
            handlerResponse.complete(
                status: 200,
                model: ModelUserRole200Add(
                    old: user!,
                    updated: try repositoryUser.getByUsername(
                        username: request.validatedRequestData?.validated["username"] as! String
                    )!
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

public class RouteUserRoleAdd: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelUserRole200Add")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestUserRoleAdd(
                method: "put",
                uri: "/api/users/{username}/role"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteUserRoleAdd
        )

    }

}