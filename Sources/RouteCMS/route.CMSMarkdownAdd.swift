import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton
import Markdown

public class RequestCMSMarkdownAdd: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Add a CMS markdown item."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateBodyHandle,
            ValidateBodyMarkdown
        ])

    }

}

public let handlerRouteCMSMarkdownAdd = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        let mdString = request.validatedRequestData?.validated["markdown"] as! String

        //FIXME - This is a hack to updated clients don't send new lines properly...
        let mdStringNL = mdString.replacingOccurrences(of: "\\n", with: "\n", options: .literal, range: nil)

        let md = try Markdown(
            string: mdStringNL
        )

        let html = try md.document()

        var repository = try RepositoryCMSMarkdown()

        var model = ModelCMSMarkdown(
            handle: request.validatedRequestData?.validated["handle"] as! String,
            markdown: mdString,
            html: html
        )

        let entity = repository.create(
            model: model
        )

        if entity.errors.isEmpty {

            //Success
            handlerResponse.complete(
                status: 200,
                model: ModelCMSMarkdown200Entity(entity: entity)
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "added": false,
                        "errors": entity.errors
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

public class RouteCMSMarkdownAdd: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelCMSMarkdown200Entity")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestCMSMarkdownAdd(
                method: "post",
                uri: "/api/cms/markdown"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteCMSMarkdownAdd
        )
    }

}