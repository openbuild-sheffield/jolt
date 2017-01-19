import Foundation
import OpenbuildExtensionCore

public struct RequestValidationTypeString: RequestValidationString {

    public var min: Int?
    public var max: Int?
    public var regex: String?
    public var email: Bool?
    public var isString: String?

    public init(){} //Used for validating something exists...

    public init(isString: String){
        self.isString = isString
    }

    public init(email: Bool){
        self.email = email
    }

    public init(min: Int, max: Int){
        self.min = min
        self.max = max
    }

    public init(regex: String){
        self.regex = regex
    }

    public init(min: Int, max: Int, regex: String){
        self.min = min
        self.max = max
        self.regex = regex
    }

    public func validate(value: Any?, required: Bool) -> [String: Any] {

        var errors: [String: Any] = [:]

        if value == nil && required {
            errors["required"] = "Is a required value."
        }

        if value != nil {

            var isString = false
            var realString: String? = nil

            if let stringValue = value! as? String {
                isString = true
                realString = stringValue
            }

            if isString {

                if self.min != nil && realString!.characters.count < self.min! {
                    errors["min"] = "Should be equal to \(self.min!) characters or higher."
                }

                if self.max != nil && realString!.characters.count > self.max! {
                    errors["max"] = "Should be equal to \(self.max!) characters or lower."
                }

                if self.regex != nil && (realString! !=~ self.regex!) {
                    errors["regex"] = "Should match \(self.regex!)."
                }

                if self.email != nil && self.email! == true {

                    if realString!.isEmail == false {
                        errors["email"] = "Should be a valid email address."
                    }

                }

                if self.isString != nil && (realString! != self.isString!) {
                    errors["match"] = "Should be equal to '\(self.isString!)'"
                }

            } else {
                errors["is_string"] = "Should be a string."
            }

        }

        return errors
    }

    public func cast(value: Any?) -> String?{

        if value == nil {
            return nil
        }

        if let stringValue = value! as? String {

            if self.email != nil && self.email! == true {
                return stringValue.lowercased()
            } else {
                return stringValue
            }

        }

        return nil

    }

    public func describeRAML() -> [String] {

        var description = [String]()

        //FIXME / TODO ? email is not a valid type but....
        if self.email != nil && self.email! {
            description.append("type: email")
        } else {
            description.append("type: string")
        }

        if self.min != nil {
            description.append("minLength: \(self.min!)")
        }

        if self.max != nil {
            description.append("maxLength: \(self.max!)")
        }

        if self.regex != nil {
            description.append("pattern: \(self.regex!)")
        }

        return description

    }

}