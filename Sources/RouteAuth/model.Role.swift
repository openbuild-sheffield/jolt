import PerfectLib
import OpenbuildExtensionPerfect

public class ModelRole: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.Role"

    public var role_id: Int?
    public var role: String?
    public var errors: [String: String] = [:]

    public init(dictionary: [String : Any]) {
        self.role_id = Int(dictionary["role_id"]! as! UInt32)
        self.role = dictionary["role"] as? String
    }

    public init(role_id: Int, role: String) {
        self.role_id = role_id
        self.role = role
    }

    public init(role_id: String, role: String) {
        self.role_id = Int(role_id)
        self.role = role
    }

    public init(role: String) {
        self.role = role
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.role_id = getJSONValue(named: "role_id", from: values, defaultValue: nil)
        self.role = getJSONValue(named: "role", from: values, defaultValue: nil)
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelRole.registerName,
            "role_id": role_id! as Int,
            "role": role! as String
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["Auth: ModelRole TODO / FIXME"]
    }

}