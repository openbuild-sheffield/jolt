import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestAuthLogout: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Allows the user to logout of the system."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

    }

}

public let handlerRouteAuthLogout = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryAuth()

        guard let token = request.token else {

            //400 Client error
            handlerResponse.complete(
                status: 400,
                model: ResponseModel400Messages(messages: [
                    "no_token": true,
                    "message": "token not found in header."
                ])
            )

            return

        }

        let deleted = repository.deleteToken(token: token)

        print("deleted: \(deleted)")

        if deleted == nil {

            handlerResponse.complete(
                status: 500,
                model: ResponseModel500Messages(messages: [
                    "token": "Failed to delete the token."
                ])
            )

        } else if deleted! {

            handlerResponse.complete(
                status: 200,
                model: ModelAuthLogout200Messages(messages: [
                    "logged_out": true,
                    "message": "You have logged out of the system."
                ])
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "invalid_token": true,
                        "message": "token not found."
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

public class RouteAuthLogout: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelAuthLogout200Messages")
        handlerResponse.register(status: 400)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestAuthLogout(
                method: "delete",
                uri: "/api/auth/login"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteAuthLogout
        )

    }

}