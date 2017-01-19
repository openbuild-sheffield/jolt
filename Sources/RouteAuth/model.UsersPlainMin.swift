import PerfectLib
import OpenbuildExtensionPerfect

public class ModelUsersPlainMin: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.UsersPlainMin"

    public var users: [ModelUserPlainMin]

    public init(users: [[String:Any]]) {

        self.users = [ModelUserPlainMin]()

        for user in users {
            self.users.append(
                ModelUserPlainMin(dictionary: user)
            )
        }

    }

    public func addUser(_ user: ModelUserPlainMin) {
        self.users.append(user)
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.users = getJSONValue(named: "users", from: values, defaultValue: [ModelUserPlainMin]())
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelUsersPlainMin.registerName,
            "users":users
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["Auth: ModelUsersPlainMin TODO / FIXME"]
    }

}