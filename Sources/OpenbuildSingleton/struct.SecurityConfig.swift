struct SecurityConfig {

    let salt: String
    let key: String
    let iv: String
    let secret: String
    let issuer: String
    let time: Int
    let audience: String
    let claims: [String: Any]

    init?(_ dict: [String: Any]){

        if dict["salt"] == nil {
            return nil
        } else {
            self.salt = dict["salt"]! as! String
        }

        if dict["key"] == nil {
            return nil
        } else {
            self.key = dict["key"]! as! String
        }

        if dict["iv"] == nil {
            return nil
        } else {
            self.iv = dict["iv"]! as! String
        }

        if dict["secret"] == nil {
            return nil
        } else {
            self.secret = dict["secret"]! as! String
        }

        if dict["issuer"] == nil {
            return nil
        } else {
            self.issuer = dict["issuer"]! as! String
        }

        if dict["time"] == nil {
            return nil
        } else {
            self.time = dict["time"]! as! Int
        }

        if dict["audience"] == nil {
            return nil
        } else {
            self.audience = dict["audience"]! as! String
        }

        if dict["claims"] == nil {
            return nil
        } else {
            self.claims = dict["claims"]! as! [String: Any]
        }

    }

}