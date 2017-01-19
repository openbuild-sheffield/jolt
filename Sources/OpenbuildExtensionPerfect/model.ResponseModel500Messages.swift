import PerfectLib

public class ResponseModel500Messages: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel500Messages"

    public var error: Bool = true
    public var message: String = "Internal server error.  This has been logged."
    public var messages: [String: Any] = [:]

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "message": "Will always be 'Internal server error.  This has been logged.'",
        "messages": "Key pair of error messages."
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
            JSONDecoding.objectIdentifierKey:ResponseModel500Messages.registerName,
            "error": error,
            "message": message,
            "messages":messages
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel500Messages") {

            return docs

        } else {

            let model = ResponseModel500Messages(messages: [
                "message": "Failed to generate a successful response."
            ])
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel500Messages", lines: docs)

            return docs

        }




/*
        var raml:[String] = ["error: boolean"]

        raml.append("errors?:")
        raml.append("  description: key/value pair describing the errors")
        raml.append("  type: object")

        raml.append("validated?:")
        raml.append("  description: validated data with possible errors")
        raml.append("  type: object")
        raml.append("  properties:")
        raml.append("    valid: boolean")
        raml.append("    validated?: object")
        raml.append("      description: key/pair of validated data")
        raml.append("    errors?: object")
        raml.append("      description: key/pair describing the errors")
        raml.append("    raw: object")
        raml.append("      description: the data sent to the server")
        raml.append("      properties:")
        raml.append("        uri?: object")
        raml.append("          description: key/value pair data sent to the server in the uri")
        raml.append("        body?: object")
        raml.append("          description: key/value pair data sent to the server in the body")

        return raml
*/
    }

}

extension ResponseModel500Messages: CustomReflectable {

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