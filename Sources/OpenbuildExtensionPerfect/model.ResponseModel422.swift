import PerfectLib

public class ResponseModel422: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel422"

    public var error: Bool = true
    public var message: String = "422 Unprocessable Entity. The request was well-formed but was unable to be followed due to semantic errors."
    public var validated: [String: Any?] = [:]
    public var messages: [String: Any] = [:]

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "message": "Will always be '422 Unprocessable Entity. The request was well-formed but was unable to be followed due to semantic errors.'",
        "validated": "Key pair description of validated data.",
        "messages": "Key pair of description messages."
    ]

    public init(validation: RequestValidation, messages: [String : Any]) {
        self.validated = validation.validated
        self.messages = messages
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "422 Unprocessable Entity. The request was well-formed but was unable to be followed due to semantic errors.")
        self.validated = getJSONValue(named: "validated", from: values, defaultValue: [:])
        self.messages = getJSONValue(named: "messages", from: values, defaultValue: [:])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel422.registerName,
            "error": error,
            "message": message,
            "validated": validated,
            "messages":messages
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel422") {

            return docs

        } else {

            var v = RequestValidation()
            v.addValidated(key: "model_id", value: 1)
            v.addValidated(key: "model_attribute", value: "fubar")

            let m: [String: Any] = [
                "updated": false,
                "errors": ["num_rows": "Failed to update correct number of rows 0"],
                "entities": [
                    "old": [
                        "model_id": 1,
                        "model_attribute": "fubar"
                    ],
                    "attempted": [
                        "model_id": 1,
                        "model_attribute": "fubar"
                    ]
                ]
            ]

            let model = ResponseModel422(validation: v, messages: m)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel422", lines: docs)

            return docs

        }

    }

}

extension ResponseModel422: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "validated": self.validated,
                "messages": self.messages
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}