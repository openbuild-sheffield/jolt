import PerfectLib

open class ResponseModel200Messages: JSONConvertibleObject {

    static let registerName = "ResponseModel200Messages"

    public var error: Bool = false
    public var message: String = "Successfully processed the request."
    public var messages: [String: Any] = [:]

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Successfully processed the request.'",
        "messages": "Key pair of messages."
    ]

    public init(messages: [String : Any]) {
        self.messages = messages
    }

    open func getRegisteredName() ->  String{
        return ResponseModel200Messages.registerName
    }

    open override func setJSONValues(_ values: [String : Any]) {
        self.error = getJSONValue(named: "error", from: values, defaultValue: false)
        self.message = getJSONValue(named: "message", from: values, defaultValue: "Successfully processed the request.")
        self.messages = getJSONValue(named: "messages", from: values, defaultValue: [:])
    }

    open override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey: self.getRegisteredName(),
            "error": error,
            "message": message,
            "messages":messages
        ]
    }

}

extension ResponseModel200Messages: CustomReflectable {

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
