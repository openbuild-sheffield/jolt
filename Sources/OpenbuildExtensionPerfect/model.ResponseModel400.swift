import PerfectLib

public class ResponseModel400: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel400"

    public var error: Bool = true
    public var message: String = "400 Client error."
    public var validated: [String: Any?] = [:]
    public var errors: [String: Any] = [:]

    public init(validation: RequestValidation) {
        self.validated = validation.validated
        self.errors = validation.errors
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "400 Client error.")
        self.validated = getJSONValue(named: "validated", from: values, defaultValue: [:])
        self.errors = getJSONValue(named: "errors", from: values, defaultValue: [:])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel400.registerName,
            "error": error,
            "message": message,
            "validated": validated,
            "errors":errors
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["ResponseModel400 TODO / FIXME"]
    }

}