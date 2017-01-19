public protocol RequestValidator {
    var validationType: String {get}
    var key: String? {get set}
    var name: String {get set}
    var required: Bool {get set}
    var validator: RequestValidationType {get}
}