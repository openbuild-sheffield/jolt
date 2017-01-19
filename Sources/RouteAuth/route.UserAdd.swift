import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestUserAdd: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Add a user."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateBodyEmail,
            ValidateBodyUsername,
            ValidateBodyPassword
        ])

    }

}

public let handlerRouteUserAdd = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryUser()

        var model = ModelUserCreate(
            username: request.validatedRequestData?.validated["username"] as! String,
            email: request.validatedRequestData?.validated["email"] as! String,
            password: request.validatedRequestData?.validated["password"] as! String
        )

        let user = repository.create(
            model: model
        )

        if user.errors.isEmpty {

            if let userPlain = try repository.getByUsername(
                username: request.validatedRequestData?.validated["username"] as! String
            ){

                //Success
                handlerResponse.complete(
                    status: 200,
                    model: ModelUser200Entity(entity: userPlain)
                )

            } else {

                //422 Unprocessable Entity
                handlerResponse.complete(
                    status: 422,
                    model: ResponseModel422(
                        validation: request.validatedRequestData!,
                    messages: [
                            "added": true,
                            "error": "Failed to read the created user."
                        ]
                    )
                )


            }

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "added": false,
                        "errors": user.errors
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

public class RouteUserAdd: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteAuth.ModelUser200Entity")
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestUserAdd(
                method: "post",
                uri: "/api/users"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteUserAdd
        )
    }

}