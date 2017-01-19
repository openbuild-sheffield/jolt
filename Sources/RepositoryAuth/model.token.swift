import PerfectLib

public class ModelToken: JSONConvertibleObject {

    static let registerName = "token"

    public var token: String
    public var secret: String

    public init(dictionary: [String : String]) {
        self.token = dictionary["token"]!
        self.secret = dictionary["secret"]!
    }

    public init(token: String, secret: String) {
        self.token = token
        self.secret = secret
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.token = getJSONValue(named: "token", from: values, defaultValue: "")
        self.secret = getJSONValue(named: "secret", from: values, defaultValue: "")
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelToken.registerName,
            "token":token,
            "secret":secret
        ]
    }

}