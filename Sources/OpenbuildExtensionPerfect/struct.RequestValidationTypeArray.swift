import OpenbuildExtensionCore

public struct RequestValidationTypeArray: RequestValidationArray {

    public var anyOnePartial: [[String:Any]]?
    public var closure: RequestValidationClosure?
    public var raml: RequestValidationRAML?

    public init(anyOnePartial: [[String:Any]]){
        self.anyOnePartial = anyOnePartial
    }

    public init(closure: @escaping RequestValidationClosure, raml: @escaping RequestValidationRAML){
        self.closure = closure
        self.raml = raml
    }

    public func validate(value: Any?, required: Bool) -> [String: Any] {

        var errors: [String: Any] = [:]

        if value == nil && required {
            errors["required"] = "Is a required value."
        }

        if value != nil {

            if self.closure != nil {

                let valueArray = value as! [Any]

                for (index, v) in valueArray.enumerated(){

                    let result = self.closure!(v)

                    if result.valid == false{
                        errors["item_\(index)"] = result.errors
                    }

                }

            }

            if self.anyOnePartial != nil {

                var matched = false

                for v in value as! [[String: Any]]{

                    if matched == false {

                        var matchedItem = false

                        for checkDict in self.anyOnePartial! {

                            for (checkKey, checkValue) in checkDict {

                                matchedItem = true

                                if v[checkKey] != nil {

                                    //TODO  add more
                                    if checkValue as? String != nil && v[checkKey] as? String != nil {

                                        if checkValue as! String == v[checkKey] as! String {
                                            matchedItem = true
                                        } else {
                                            matchedItem = false
                                        }

                                    } else {
                                        matchedItem = false
                                    }

                                } else {
                                    matchedItem = false
                                }

                            }

                            if matchedItem && matched == false {
                                matched = true
                            }

                        }

                    }

                }

                if matched == false {
                    errors["matched"] = "Does not meet requirements. \(self.anyOnePartial!)"
                }

            }

        }

        return errors

    }

    public func cast(value: Any?) -> [Any]? {

        if value != nil {
            return (value as! [Any])
        }

        return nil

    }

    public func describeRAML() -> [String] {

        if self.raml != nil {
            return self.raml!()
        } else {
            return ["TODO - describeRAML array"]
        }

    }

}