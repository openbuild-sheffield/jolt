import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class RequestCMSWordsUpdate: OpenbuildExtensionPerfect.RequestProtocol {

    public var method: String
    public var uri: String
    public var description: String = "Update a CMS words entity by handle."
    public var validation: OpenbuildExtensionPerfect.RequestValidation

    public init(method: String, uri: String){

        self.method = method
        self.uri = uri
        self.validation = OpenbuildExtensionPerfect.RequestValidation()

        self.validation.addValidators(validators: [
            ValidateTokenRoles,
            ValidateUriHandle,
            ValidateBodyWords
        ])

    }

}

public let handlerRouteCMSWordsUpdate = { (request: HTTPRequest, response: HTTPResponse) in

    guard let handlerResponse = RouteRegistry.getHandlerResponse(
        uri: request.path.lowercased(),
        method: request.method,
        response: response
    ) else {
        return
    }

    do {

        var repository = try RepositoryCMSWords()

        guard let oldEntity = try repository.getByHandle(
            handle: request.validatedRequestData?.validated["handle"] as! String
        ) else {

            handlerResponse.complete(
                status: 404,
                model: ResponseModel404(uri: request.uri, method: request.method.description)
            )

            return

        }

        var model = ModelCMSWords(
            cms_words_id: oldEntity.cms_words_id!,
            handle: request.validatedRequestData?.validated["handle"] as! String,
            words: request.validatedRequestData?.validated["words"] as! String
        )


        let updatedEntity = repository.update(
            model: model
        )

        if updatedEntity.errors.isEmpty {

            handlerResponse.complete(
                status: 200,
                model: ModelCMSWords200Update(old: oldEntity, updated: updatedEntity)
            )

        } else {

            //422 Unprocessable Entity
            handlerResponse.complete(
                status: 422,
                model: ResponseModel422(
                    validation: request.validatedRequestData!,
                    messages: [
                        "updated": false,
                        "errors": updatedEntity.errors,
                        "entities": ["old": oldEntity, "attempted": updatedEntity]
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

public class RouteCMSWordsUpdate: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {

        let handlerResponse = ResponseDefined()
        handlerResponse.register(status: 200, model: "RouteCMS.ModelCMSWords200Update")
        handlerResponse.register(status: 403)
        handlerResponse.register(status: 404)
        handlerResponse.register(status: 422)
        handlerResponse.register(status: 500)

        return NamedRoute(
            handlerRequest: RequestCMSWordsUpdate(
                method: "put",
                uri: "/api/cms/words/{handle}"
            ),
            handlerResponse: handlerResponse,
            handlerRoute: handlerRouteCMSWordsUpdate
        )

    }

}