import PerfectLib
import PerfectHTTP
import JWT

public struct RequestValidation {

    public var validators: [RequestValidator]
    public var valid: Bool
    public var validated: [String: Any?]
    public var raw: [String: Any]?
    public var errors: [String: Any]
    public var permissionErrors: [String: Any]

    public init() {
        validators = []
        valid = true
        validated = [:]
        raw = [:]
        errors = [:]
        permissionErrors = [:]
    }

    public init(valid: Bool, validated: [String: Any], raw: [String: Any]?, errors: [String: Any]) {

        validators = []
        self.valid = valid
        self.validated = validated
        self.raw = raw
        self.errors = errors
        self.permissionErrors = [:]

        if raw == nil {
            self.addError(key: "request", value: "The request contains no data.")
        }

    }

    public init(raw: [String: Any]?){

        validators = []
        self.valid = true
        self.validated = [:]
        self.raw = raw
        self.errors = [:]
        self.permissionErrors = [:]

        if raw == nil {
            self.addError(key: "request", value: "The request contains no data.")
        }

    }

    public mutating func addError(key: String, value: Any) {
        self.valid = false
        self.errors[key] = value
    }

    public mutating func addErrorToken(key: String, value: Any) {
        self.valid = false
        self.permissionErrors[key] = value
    }

    public mutating func addValidated(key: String, value: Any?) {
        self.validated[key] = value
    }

    public mutating func addValidated(key: String, value: Int?) {
        self.validated[key] = value
    }

    public mutating func addValidators(validators: [RequestValidator]) {
        self.validators = validators
    }

    public mutating func validate(request: HTTPRequest) {

        self.raw!["token"] = request.decodedToken
        self.raw!["uri"] = request.urlVariables
        self.raw!["body"] = request.bodyParams
        self.raw!["files"] = request.files

        let data = self.validators
print("DO VALIDATION \(data)")

        let uriData = self.raw?["uri"] as? [String: Any]
        let bodyData = self.raw?["body"] as? [String: Any]
        let fileData = self.raw?["files"] as? [String: Any]
        let token = self.raw?["token"] as? JWT.ClaimSet
        let tokenData = token?["data"] as? [String: [String: Any]]

print("")
print(self.raw as Any)
//print(self.raw?["token"])
print(token as Any)
print(tokenData as Any)
print("")

print("uriData: \(uriData)")
print("bodyData: \(bodyData)")
print("fileData: \(fileData)")
print("tokenData: \(tokenData)")

        for validate in data {

            print("DO: \(validate)")

            var value: Any?

            switch validate.validationType {
                case "uri":
                    value = uriData?[validate.name]
                case "body":
                    value = bodyData?[validate.name]
                case "token":
                    value = tokenData?[validate.key!]?[validate.name]
                default:
                    print("Should not be here")
            }

            print("")
            print("VALUE: \(validate.name) : \(value)")
            print("")

            if validate.validationType == "token" && tokenData == nil{

                self.addErrorToken(key: "token", value: "Token is invalid/not set, please login.")

            } else if value == nil && validate.required {

                self.addError(key: validate.name, value: "Is a required value.")

            } else {

                let validator = validate.validator
                let errors = validator.validate(value: value, required: validate.required)

                if errors.isEmpty == false {

                    if validate.validationType == "token" {
                        self.addErrorToken(key: validate.name, value: errors)
                    } else {
                        self.addError(key: validate.name, value: errors)
                    }

                }else{

                    if let ArrayType = validator as? RequestValidationArray {
                        self.addValidated(key: validate.name, value: ArrayType.cast(value: value))
                    }

                    if let IntType = validator as? RequestValidationInt {
                        self.addValidated(key: validate.name, value: IntType.cast(value: value))
                    }

                    if let StringType = validator as? RequestValidationString {
                        self.addValidated(key: validate.name, value: StringType.cast(value: value))
                    }

                }

            }

            // Remove token from raw
            if self.raw != nil {
                self.raw!.removeValue(forKey: "token")
            }

        }

    }

}