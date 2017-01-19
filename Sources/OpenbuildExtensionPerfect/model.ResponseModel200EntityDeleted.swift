import PerfectLib

open class ResponseModel200EntityDeleted: JSONConvertibleObject {

    static let registerName = "responseModel200EntityDeleted"

    public var error: Bool = false
    public var message: String = "Successfully deleted the entity."
    public var deleted: JSONConvertibleObject

    public init(deleted: JSONConvertibleObject) {
        self.deleted = deleted
    }

    open override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ResponseModel200EntityDeleted.registerName,
            "error": error,
            "message": message,
            "deleted": deleted
        ]
    }

}