public protocol RequestValidationType {

    func validate(value: Any?, required: Bool) -> [String: Any]
    func describeRAML() -> [String]

}

public protocol RequestValidationArray: RequestValidationType{

    func cast(value: Any?) -> [Any]?

}

public protocol RequestValidationInt: RequestValidationType{

    func cast(value: Any?) -> Int?

}

public protocol RequestValidationString: RequestValidationType{

    func cast(value: Any?) -> String?

}