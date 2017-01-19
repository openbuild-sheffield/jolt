import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestCMSMarkdownDelete: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Delete a CMS markdown entity by handle."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateUriHandle
        ])

    }


}

public let handlerRouteCMSMarkdownDelete = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryCMSMarkdown()

        guard let model = try repository.getByHandle(
            handle: request.validatedRequestData?.validated["handle"] as! String
        ) else {

            handlerResponse.complete(
                status: 404,
                model: ResponseModel404(uri: request.uri, method: request.method.description)
            )

            return

        }

        let deletedCMS = repository.delete(
            model: model
        )

        if deletedCMS.errors.isEmpty {

            handlerResponse.complete(
                status: 200,
                model: ModelCMSMarkdown200Delete(deleted: deletedCMS)
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "deleted": false,
                        "errors": deletedCMS.errors,
                        "entity": deletedCMS
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

public class RouteCMSMarkdownDelete: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelCMSMarkdown200Delete")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 404)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestCMSMarkdownDelete(
                method: "delete",
                uri: "/api/cms/markdown/{handle}"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteCMSMarkdownDelete
        )
    }

}