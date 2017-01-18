struct ServerConfig {

    let address: String
    let documentRoot: String
    let name: String
    let port: UInt16
    let runAsUser: String
    //var ssl: ServerConfigSSL

    init?(_ dict: [String: Any]){

        if dict["documentRoot"] == nil {
            return nil
        } else {
            self.documentRoot = dict["documentRoot"]! as! String
        }

        if dict["port"] == nil {
            return nil
        } else {
            self.port = UInt16(dict["port"]! as! Int)
        }

        if dict["address"] == nil {
            return nil
        } else {
            self.address = dict["address"]! as! String
        }

        if dict["runAsUser"] == nil {
            return nil
        } else {
            self.runAsUser = dict["runAsUser"]! as! String
        }

        if dict["name"] == nil {
            return nil
        } else {
            self.name = dict["name"]! as! String
        }

        //TODO
        //self.ssl = ServerConfigSSL(dict["ssl"]! as! [String:String])

    }

}

struct ServerConfigSSL {
    var cert: String
    var key: String
}