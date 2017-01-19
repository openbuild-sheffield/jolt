import OpenbuildExtensionCore

public struct RequestValidationTypeInt: RequestValidationInt {

    public var min: Int?
    public var max: Int?

    public init(min: Int, max: Int){
        self.min = min
        self.max = max
    }

    public func validate(value: Any?, required: Bool) -> [String: Any] {

        var errors: [String: Any] = [:]

        if value == nil && required {
            errors["required"] = "Is a required value."
        }

        if value != nil {

            var isInt = false
            var realInt: Int? = nil

            if let intValue = value! as? Int {

                isInt = true
                realInt = intValue

            } else if let intValue = value! as? String {

                if intValue.isInt {
                    isInt = true
                    realInt = intValue.toInt
                }

            }

            if isInt {

                if self.min != nil && realInt! < self.min! {
                    errors["min"] = "Should be equal to \(self.min!) or higher."
                }

                if self.max != nil && realInt! > self.max! {
                    errors["max"] = "Should be equal to \(self.max!) or lower."
                }

            } else {
                errors["is_int"] = "Should be an integer number."
            }

        }

        return errors
    }

    public func cast(value: Any?) -> Int?{

        if value == nil {
            return nil
        }

        if let intValue = value! as? Int {
            return intValue
        }

        if let stringValue = value! as? String {

            if stringValue.isInt {
                return stringValue.toInt
            }

        }

        return nil

    }

    public func describeRAML() -> [String] {

        var description = [String]()

        description.append("type: integer")

        if self.min != nil {
            description.append("minimum: \(self.min!)")
        }

        if self.max != nil {
            description.append("maximum: \(self.max!)")
        }

        return description

    }

}