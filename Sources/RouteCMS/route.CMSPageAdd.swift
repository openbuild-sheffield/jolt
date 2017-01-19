import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestCMSPageAdd: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Add a CMS page."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){


        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            //ValidateTokenRoles,
            ValidateBodyPageURI,
            ValidateBodyTemplatePath,
            ValidateBodyPageTitle,
            ValidateBodyPageDescription,
            ValidateBodyPageVariables
        ])

    }

}

public let handlerRouteCMSPageAdd = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    print("handlerRouteCMSWordsAdd")
    print()
    print(request.validatedRequestData as Any)
    print(request.validatedRequestData?.validated["uri"] as! String)
    print(request.validatedRequestData?.validated["template_path"] as! String)
    print(request.validatedRequestData?.validated["title"] as! String)
    print(request.validatedRequestData?.validated["description"] as! String)
    print(request.validatedRequestData?.validated["variables"] as! [Any])
//    response.appendBody(string: "handlerRouteCMSWordsAdd")

//    response.completed()

    do {

        var repository = try RepositoryCMSPage()

        var model = ModelCMSPage(
            uri: request.validatedRequestData?.validated["uri"] as! String,
            template_path: request.validatedRequestData?.validated["template_path"] as! String,
            title: request.validatedRequestData?.validated["title"] as! String,
            description: request.validatedRequestData?.validated["description"] as! String,
            variables: request.validatedRequestData?.validated["variables"] as! [Any]
        )

        let entity = repository.create(
            model: model
        )

        if entity.errors.isEmpty {

            //Success
            handlerResponse.complete(
                status: 200,
                model: ModelCMSPage200Entity(entity: entity)
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

public class RouteCMSPageAdd: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelCMSPage200Entity")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestCMSPageAdd(
                method: "post",
                uri: "/api/cms/page"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteCMSPageAdd
        )
    }

}