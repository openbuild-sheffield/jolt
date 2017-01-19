import PerfectLib

public class ResponseModel500: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel500"

    public var error: Bool = true
    public var message: String = "Internal server error, no additional details were provided.  This has been logged."

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "message": "Will always be 'Internal server error, no additional details were provided.  This has been logged.'"
    ]

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "Internal server error, no additional details were provided.  This has been logged.")
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: ResponseModel500.registerName,
            "error": error,
            "message": message
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel500") {

            return docs

        } else {

            let model = ResponseModel500()
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel500", lines: docs)

            return docs

        }

    }

}

extension ResponseModel500: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}