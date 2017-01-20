import CryptoSwift
import Foundation
import JWT
import PerfectLib

public class Security {

    private var salt: String
    private var key: String
    private var iv: String
    private var cipher: ChaCha20

    private var secret: String
    private var issuer: String
    private var time: Int

    private var defaultAudience: String
    private var defaultClaims: [String: Any]

    public init(salt: String, key: String, iv: String, secret: String, issuer: String, time: Int, audience: String, claims: [String: Any]){

        //Encryption
        self.salt = salt
        self.key = key
        self.iv = iv

        let p1 = "password".utf8.map({$0})
        let s1 = "salt".utf8.map({$0})

        do {
            print("GENERATING REAL KEY AND IV")
            let key: [UInt8] = try CryptoSwift.PKCS5.PBKDF2(password: p1, salt: s1, iterations: 4096, variant: CryptoSwift.HMAC.Variant.sha256).calculate()
            let iv: [UInt8] = try CryptoSwift.PKCS5.PBKDF2(password: p1, salt: s1, iterations: 4096, variant: CryptoSwift.HMAC.Variant.sha256).calculate()
            let ivFirst12 = Array(iv.prefix(12))
            print("GENERATED REAL KEY AND IV")
            self.cipher = try ChaCha20(key: key, iv: ivFirst12)
        } catch {
            print("Failed security, could not create key or iv")
            exit(0)
        }

        //JTW
        self.secret = secret
        self.issuer = issuer
        self.time = time

        //JWT defaults
        self.defaultAudience = audience
        self.defaultClaims = claims

    }

    public convenience init(path: String){

        do {

            let configURL = URL(fileURLWithPath: path)
            let configData = try Data(contentsOf:configURL)
            let configDictionary = try PropertyListSerialization.propertyList(from: configData, options: [], format: nil) as! [String:Any]

            let securityConfig = SecurityConfig(configDictionary["security"] as! [String: Any])

            if securityConfig == nil {

                print("Load config.plist error - Invalid security details")
                print(configDictionary["security"] as Any)
                exit(0)

            } else {

                self.init(
                    salt: securityConfig!.salt,
                    key: securityConfig!.key,
                    iv: securityConfig!.iv,
                    secret: securityConfig!.secret,
                    issuer: securityConfig!.issuer,
                    time: securityConfig!.time,
                    audience: securityConfig!.audience,
                    claims: securityConfig!.claims
                )

            }

        } catch {
            print("Failed to load config file")
            exit(0)
        }

    }

    public func randomString() -> String {

        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var random:String = ""
        for _ in (1...128) {
            random.append(c[Int(arc4random()) % c.count])
        }

        return random

    }

    public func hash(salt: String, contents: String) -> String {

        let contentsWithSalt = salt + contents + self.salt
        return contentsWithSalt.sha512()

    }

    public func hashMatch(salt: String, contents: String, hash: String) -> Bool {
        return hash == self.hash(salt: salt, contents: contents)
    }

    public func JWTEncode(secret: String, audience: String, claims: [String:Any]?=nil, data: Any?) -> String? {

        let saltedSecret = secret + self.secret

        let encoded = JWT.encode(JWT.Algorithm.hs512(saltedSecret.data(using: .utf8)!)) { builder in

            if claims != nil {
                for (key, value) in claims! {
                    builder[key] = value
                }
            }



            builder.issuer = self.issuer
            builder.audience = audience
            builder.issuedAt = Date()
            builder.expiration = Date(timeIntervalSinceNow: Double(self.time))
            builder.notBefore = Date()
            if data != nil {
                builder["data"] = data!
            }

        }

        return encoded

    }

    public func JWTDecode(secret: String, encodedToken: String) throws -> JWT.ClaimSet? {

        let saltedSecret = secret + self.secret

        do {

            let decoded = try JWT.decode(encodedToken, algorithms: [
                JWT.Algorithm.hs256(saltedSecret.data(using: .utf8)!),
                JWT.Algorithm.hs256(saltedSecret.data(using: .utf8)!),
                JWT.Algorithm.hs512(saltedSecret.data(using: .utf8)!)
            ]) as JWT.ClaimSet

            return decoded

        } catch {

            print("Invalid JTW decode \(error)")
            throw error

        }

    }

    public func JWTValidate(claimSet: JWT.ClaimSet, audience: String, claims: [String:Any]?=nil) -> Bool? {

        do {

            try claimSet.validateExpiary()
            try claimSet.validateNotBefore()
            try claimSet.validateIssuedAt()

            try claimSet.validateAudience(audience)
            try claimSet.validateIssuer(self.issuer)

            if claims != nil {
                for (key, value) in claims! {
                    if String(describing: claimSet[key]!) != String(describing: value) {
                        print("Invalid JWT claim \(key), expected: \(value) got: \(claimSet[key]!)")
                        return false
                    }
                }
            }

        } catch {
            return false
        }

        return true

    }

    public func getDefaultAudience() -> String {
        return self.defaultAudience
    }

    public func getDefaultClaims() -> [String: Any] {
        return self.defaultClaims
    }

    public func encrypt(toEncrypt: String) -> String? {

        do {

            return try self.cipher.encrypt(toEncrypt.utf8.map({$0})).toBase64()

        } catch {
            print("Failed to encrypt")
            return nil
        }

    }

    public func decrypt(toDecrypt: String) -> String? {

        do {

            return try toDecrypt.decryptBase64ToString(cipher: self.cipher)

        } catch {

            print("Failed to decrypt")
            return nil

        }

    }

    public func getTimeout() -> Int {
        return self.time
    }

}