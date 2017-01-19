import PerfectLib
import PerfectHTTP

public protocol RequestProtocol {

    var method: String {get set}
    var uri: String {get set}
    var description: String {get set}
    var validation: RequestValidation {get set}

    func getValidation() -> RequestValidation
    func getDocumentation(handlerResponse: ResponseDefined) -> RequestDocumentation
    func validate(request: HTTPRequest) -> RequestValidation

}

public extension RequestProtocol {

    public final func getValidation() -> RequestValidation {
        return self.validation
    }

    public final func getDocumentation(handlerResponse: ResponseDefined) -> RequestDocumentation {

        return OpenbuildExtensionPerfect.RequestDocumentation(
            method: self.method,
            uri: self.uri,
            validation: self.validation,
            handlerResponse: handlerResponse
        )

    }

    public final func validate(request: HTTPRequest) -> RequestValidation {
        var validation = self.validation
        validation.validate(request: request)
        return validation
    }

}