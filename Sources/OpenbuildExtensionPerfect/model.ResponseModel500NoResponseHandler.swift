import PerfectLib

public class ResponseModel500NoResponseHandler: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel500NoResponseHandler"

    public var error: Bool = true
    public var message: String = "Internal server error.  This has been logged."
    public var messages: [String: String] = ["response_handler": "The developer did not provide a response handler."]

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "Internal server error.  This has been logged.")
        self.messages = getJSONValue(named: "messages", from: values, defaultValue: ["response_handler": "The developer did not provide a response handler."])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: ResponseModel500NoResponseHandler.registerName,
            "error": error,
            "message": message,
            "messages": messages
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["ResponseModel500NoResponseHandler TODO / FIXME"]
    }

}