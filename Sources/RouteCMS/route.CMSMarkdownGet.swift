import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestCMSMarkdownGet: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Get a CMS markdown entity by handle."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateUriHandle
        ])

    }

}

public let handlerRouteCMSMarkdownGet = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryCMSMarkdown()

        let entity = try repository.getByHandle(
            handle: request.validatedRequestData?.validated["handle"] as! String
        )

        if entity == nil {

            handlerResponse.complete(
                status: 404,
                model: ResponseModel404(uri: request.uri, method: request.method.description)
            )

        } else {

            //Success
            handlerResponse.complete(
                status: 200,
                model: ModelCMSMarkdown200Entity(entity: entity!)
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

public class RouteCMSMarkdownGet: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelCMSMarkdown200Entity")
        handlerResponse.register(status: 404)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestCMSMarkdownGet(
                method: "get",
                uri: "/api/cms/markdown/{handle}"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteCMSMarkdownGet
        )

    }

}