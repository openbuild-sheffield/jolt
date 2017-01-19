import PerfectLib
import OpenbuildSingleton

public class ModelUserCreate {

    public var username: String
    public var secret: String
    public var email: String
    public var password: String
    public var errors: [String: String] = [:]

    public init(
        username: String,
        email: String,
        password: String
    ) {

        let security = OpenbuildSingleton.Manager.getSecurity()
        let secret = security.randomString()
        self.username = username
        self.secret = secret
        self.email = security.encrypt(toEncrypt: email)!
        self.password = security.hash(salt: secret, contents: password)

    }

}