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

public class RequestGenerateHTMLFromMarkdown: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Generates HTML from Markdown."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateBodyMarkdown
        ])

    }

}

public let handlerRouteGenerateHTMLFromMarkdown = { (request: HTTPRequest, response: HTTPResponse) in

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

        //Success
        handlerResponse.complete(
            status: 200,
            model: ModelGenerateHTMLFromMarkdown(markdown:mdStringNL, html: html)
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

public class RouteGenerateHTMLFromMarkdown: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelGenerateHTMLFromMarkdown")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestGenerateHTMLFromMarkdown(
                method: "post",
                uri: "/api/cms/markdown/generatehtml"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteGenerateHTMLFromMarkdown
        )

    }

}