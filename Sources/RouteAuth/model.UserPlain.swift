import PerfectLib
import OpenbuildExtensionPerfect

public class ModelUserPlain: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.UserPlain"

    public var user_id: Int?
    public var username: String
    public var secret: String
    public var email: String
    public var password: String
    public var passwordUpdate: Bool
    public var created: String //TODO make date
    public var roles: [ModelRole]
    public var errors: [String: String] = [:]

    public init(dictionary: [String : Any]) {

        self.user_id = Int(dictionary["user_id"]! as! UInt32)
        self.username = dictionary["username"]! as! String
        self.secret = dictionary["secret"]! as! String
        self.email = dictionary["email"]! as! String
        self.password = dictionary["password"]! as! String
        self.passwordUpdate = dictionary["passwordUpdate"]! as! Bool
        self.created = dictionary["created"]! as! String

        let rolesModel = ModelRoles(roles: dictionary["roles"]! as! [[String:Any]])
        self.roles = rolesModel.roles

    }

    public init(
        user_id: Int,
        username: String,
        secret: String,
        email: String,
        password: String,
        passwordUpdate: Bool,
        created: String,
        roles: [[String:Any]]
    ) {
        self.user_id = user_id
        self.username = username
        self.secret = secret
        self.email = email
        self.password = password
        self.passwordUpdate = passwordUpdate
        self.created = created

        let rolesModel = ModelRoles(roles: roles)
        self.roles = rolesModel.roles

    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.user_id = getJSONValue(named: "user_id", from: values, defaultValue: nil)
        self.username = getJSONValue(named: "username", from: values, defaultValue: "")
        self.secret = getJSONValue(named: "secret", from: values, defaultValue: "")
        self.email = getJSONValue(named: "email", from: values, defaultValue: "")
        self.password = getJSONValue(named: "password", from: values, defaultValue: "")
        self.passwordUpdate = getJSONValue(named: "passwordUpdate", from: values, defaultValue: false)
        self.created = getJSONValue(named: "created", from: values, defaultValue: "")
        self.roles = getJSONValue(named: "roles", from: values, defaultValue: [])
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelUserPlain.registerName,
            "user_id":user_id as Any,
            "username":username,
            "secret":secret,
            "email":email,
            "password":password,
            "passwordUpdate":passwordUpdate,
            "created":created,
            "roles":roles
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["Auth: ModelUserPlain TODO / FIXME"]
    }

}