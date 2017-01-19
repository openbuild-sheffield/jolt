import PerfectLib

open class ResponseModel200Entities: JSONConvertibleObject {

    static let registerName = "responseModel200Entities"

    public var error: Bool = false
    public var message: String = "Successfully fetched the entities."
    public var entities: JSONConvertibleObject

    public init(entities: JSONConvertibleObject) {
        self.entities = entities
    }

    open override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel200Entities.registerName,
            "error": error,
            "message": message,
            "entities": entities
        ]
    }

}