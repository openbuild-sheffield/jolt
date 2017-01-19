import PerfectLib

public class ResponseModel400Messages: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel400Messages"

    public var error: Bool = true
    public var message: String = "400 Client error."
    public var messages: [String: Any] = [:]

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "message": "Will always be '400 Client error.'",
        "messages": "Key pair of description of errors."
    ]

    public init(messages: [String : Any]) {
        self.messages = messages
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "Internal server error.  This has been logged.")
        self.messages = getJSONValue(named: "messages", from: values, defaultValue: [:])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel400Messages.registerName,
            "error": error,
            "message": message,
            "messages":messages
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel400Messages") {

            return docs

        } else {

            let model = ResponseModel400Messages(messages: [
                "no_token": true,
                "message": "token not found in header."
            ])
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel400Messages", lines: docs)

            return docs

        }

    }

}

extension ResponseModel400Messages: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "messages": self.messages
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}