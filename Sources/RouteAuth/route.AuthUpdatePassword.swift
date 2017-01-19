import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestAuthUpdatePassword: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Allows the user to update their password."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateBodyUsername,
            ValidateBodyEmail,
            ValidateBodyPassword,
            ValidateBodyNewPassword
        ])

    }

}

public let handlerRouteAuthUpdatePassword = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryAuth()

        guard let user = try repository.getByUsernameEmailPassword(
            username: request.validatedRequestData?.validated["username"] as! String,
            email: request.validatedRequestData?.validated["email"] as! String,
            password: request.validatedRequestData?.validated["password"] as! String
        ) else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "invalid_login": true,
                        "message": "username/password not found."
                    ]
                )
            )

            return

        }

        let security = OpenbuildSingleton.Manager.getSecurity()

        user.password = security.hash(
            salt: user.secret,
            contents: request.validatedRequestData?.validated["new_password"] as! String
        )

        var updatedUser = repository.updatePassword(
            model: user
        )

        if updatedUser.errors.isEmpty {

            handlerResponse.complete(
                status: 200,
                model: ModelAuthUpdatePassword200Messages(messages: [
                    "updated": true,
                    "message": "User password has been updated."
                ])
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "updated": false,
                        "errors": updatedUser.errors
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

public class RouteAuthUpdatePassword: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelAuthUpdatePassword200Messages")
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestAuthUpdatePassword(
                method: "put",
                uri: "/api/auth/update/password"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteAuthUpdatePassword
        )

    }

}