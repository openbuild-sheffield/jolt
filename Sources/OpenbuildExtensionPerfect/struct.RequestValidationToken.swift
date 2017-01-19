public struct RequestValidationToken: RequestValidator {

    private var _key: String
    private var _name: String
    private var _required: Bool
    public var type: RequestValidationType

    public var key: String? {
        get {
            return self._key
        }
        set(newValue) {
            self._key = newValue!
        }
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
        return "token"
    }

    public var validator: RequestValidationType {
        get {
            return self.type
        }
    }

    public init(key: String, name: String, required: Bool, type: RequestValidationType){
        self._key = key
        self._name = name
        self._required = required
        self.type = type
    }

}