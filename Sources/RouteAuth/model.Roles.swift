import PerfectLib
import OpenbuildExtensionPerfect

public class ModelRoles: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.Roles"

    public var roles: [ModelRole]

    public override init() {
        self.roles = [ModelRole]()
        super.init()
    }

    public init(roles: [[String:Any]]) {

        self.roles = [ModelRole]()

        for role in roles {
            self.roles.append(
                ModelRole(dictionary: role)
            )
        }

    }

    public func addRole(_ role: ModelRole) {
        self.roles.append(role)
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.roles = getJSONValue(named: "roles", from: values, defaultValue: [ModelRole]())
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelRoles.registerName,
            "roles":roles
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["Auth: ModelRoles TODO / FIXME"]
    }

}