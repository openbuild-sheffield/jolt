public struct RequestValidationUri: RequestValidator {

    private var _name: String
    private var _required: Bool
    public var type: RequestValidationType

    public var key: String? {
        get {
            return nil
        }
        set(newValue) {}
    }

    public var name: String {
        get {
            return self._name
        }
        set(newValue) {
            self._name = newValue
        }
    }

    public var required: Bool {
        get {
            return self._required
        }
        set(newValue) {
            self._required = newValue
        }
    }

    public var validationType: String {
        return "uri"
    }

    public var validator: RequestValidationType {
        get {
            return self.type
        }
    }

    public init(name: String, required: Bool, type: RequestValidationType){
        self._name = name
        self._required = required
        self.type = type
    }

}