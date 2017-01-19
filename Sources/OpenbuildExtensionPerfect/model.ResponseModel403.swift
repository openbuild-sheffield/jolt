import PerfectLib

public class ResponseModel403: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel403"

    public var error: Bool = true
    public var message: String = "403 Unauthorised."
    public var errors: [String: Any] = [:]

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "message": "Will always be '403 Unauthorised.'",
        "errors": "Key pair of description of errors."
    ]

    public init(validation: RequestValidation) {
        self.errors = validation.permissionErrors
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "403 Unauthorised.")
        self.errors = getJSONValue(named: "errors", from: values, defaultValue: [:])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel403.registerName,
            "error": error,
            "message": message,
            "errors":errors
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel403") {

            return docs

        } else {

            var v = RequestValidation()
            v.addErrorToken(key: "token", value: "Token is invalid/not set, please login.")

            let model = ResponseModel403(validation: v)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel403", lines: docs)

            return docs

        }

    }

}

extension ResponseModel403: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "errors": self.errors
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}