import PerfectLib

open class ResponseModel200Entity: JSONConvertibleObject {

    static let registerName = "responseModel200Entity"

    public var error: Bool = false
    public var message: String = "Successfully created/fetched the entity."
    public var entity: JSONConvertibleObject

    public init(entity: JSONConvertibleObject) {
        self.entity = entity
    }

    open override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel200Entity.registerName,
            "error": error,
            "message": message,
            "entity": entity
        ]
    }

}