import PerfectLib
import Foundation

public class ResponseModel404: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "responseModel404"

    public var error: Bool = true
    public var uri: String
    public var method: String
    public var message: String = "Resource not found."

    public var descriptions = [
        "error": "An error has occurred, will always be true",
        "uri": "The path of the URI that was not found",
        "method": "The http request method that was not found for the URI",
        "message": "The error that occurred"
    ]

    public init(uri: String, method: String) {

        self.uri = uri
        self.method = method

    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: true)
        self.uri = getJSONValue(named: "uri", from: values, defaultValue: "")
        self.method = getJSONValue(named: "method", from: values, defaultValue: "")
        self.message = getJSONValue(named: "method", from: values, defaultValue: "Resource not found.")
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: ResponseModel404.registerName,
            "error": error,
            "uri": uri,
            "method": method,
            "message": message
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ResponseModel404") {

            return docs

        } else {

            let model = ResponseModel404(uri: "/test", method: "get")
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ResponseModel404", lines: docs)

            return docs

        }

    }

}

extension ResponseModel404: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "uri": self.uri,
                "method": self.method,
                "message": self.message
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
//            ancestorRepresentation: .Customized(super.customMirror)

    }

}