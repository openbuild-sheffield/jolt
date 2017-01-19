import PerfectLib

open class ResponseModel200EntityUpdated: JSONConvertibleObject {

    static let registerName = "responseModel200EntityUpdated"

    public var error: Bool = false
    public var message: String = "Successfully updated the entity."
    public var old: JSONConvertibleObject
    public var updated: JSONConvertibleObject

    public init(old: JSONConvertibleObject, updated: JSONConvertibleObject) {
        self.old = old
        self.updated = updated
    }

    open override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel200EntityUpdated.registerName,
            "error": error,
            "message": message,
            "old": old,
            "updated": updated
        ]
    }

}