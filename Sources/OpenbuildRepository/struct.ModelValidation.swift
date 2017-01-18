public struct ModelValidation {

    public var valid: Bool
    public var validated: [String: Any]
    public var raw: [String: Any]?
    public var errors: [String: Any]

    public init() {
        valid = true
        validated = [:]
        raw = [:]
        errors = [:]
    }

    public init(valid: Bool, validated: [String: Any], raw: [String: Any]?, errors: [String: Any]) {

        self.valid = valid
        self.validated = validated
        self.raw = raw
        self.errors = errors

        if raw == nil {
            self.addError(key: "request", value: "The request contains no data.")
        }

    }

    public init(raw: [String: Any]?){

        self.valid = true
        self.validated = [:]
        self.raw = raw
        self.errors = [:]

        if raw == nil {
            self.addError(key: "request", value: "The request contains no data.")
        }

    }

    public mutating func addError(key: String, value: Any) {
        self.valid = false
        self.errors[key] = value
    }

    public mutating func addValidated(key: String, value: Any) {
        self.validated[key] = value
    }

}