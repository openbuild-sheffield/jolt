import PerfectLib
import OpenbuildExtensionPerfect
import OpenbuildSingleton

public class ModelUserPlainMin: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.UserPlainMin"

    public var user_id: Int?
    public var username: String
    public var email: String
    public var passwordUpdate: Bool
    public var created: String //TODO make date
    public var roles: [ModelRole]
    public var errors: [String: String] = [:]

    public init(dictionary: [String : Any]) {

        let security = OpenbuildSingleton.Manager.getSecurity()

        self.user_id = Int(dictionary["user_id"]! as! UInt32)
        self.username = dictionary["username"]! as! String
        self.email = security.decrypt(toDecrypt: dictionary["email"]! as! String)!

        if dictionary["passwordUpdate"]! as! Int8 == 1 {
            self.passwordUpdate = true
        } else {
            self.passwordUpdate = false
        }

        self.created = dictionary["created"]! as! String

        let rolesModel = ModelRoles(roles: dictionary["roles"]! as! [[String:Any]])
        self.roles = rolesModel.roles

    }

    public init(
        user_id: Int,
        username: String,
        email: String,
        passwordUpdate: Bool,
        created: String,
        roles: [[String:Any]]
    ) {
        self.user_id = user_id
        self.username = username
        self.email = email
        self.passwordUpdate = passwordUpdate
        self.created = created

        let rolesModel = ModelRoles(roles: roles)
        self.roles = rolesModel.roles

    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.user_id = getJSONValue(named: "user_id", from: values, defaultValue: nil)
        self.username = getJSONValue(named: "username", from: values, defaultValue: "")
        self.email = getJSONValue(named: "email", from: values, defaultValue: "")
        self.passwordUpdate = getJSONValue(named: "passwordUpdate", from: values, defaultValue: false)
        self.created = getJSONValue(named: "created", from: values, defaultValue: "")
        self.roles = getJSONValue(named: "roles", from: values, defaultValue: [])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelUserPlainMin.registerName,
            "user_id":user_id as Any,
            "username":username,
            "email":email,
            "passwordUpdate":passwordUpdate,
            "created":created,
            "roles":roles
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["Auth: ModelUserPlainMin TODO / FIXME"]
    }

}