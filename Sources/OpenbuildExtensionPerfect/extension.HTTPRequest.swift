import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import OpenbuildExtensionCore
import OpenbuildSingleton
import RepositoryAuth
import JWT

public extension HTTPRequest {

    public var token: String? {
        return self.header(HTTPRequestHeader.Name.custom(name: "token"))
    }

    //Returns a  decoded JTW token
    public var decodedToken: JWT.ClaimSet? {

        do{

            let auth = try RepositoryAuth.Auth()

            let token = self.token

            if token != nil {

                let modelToken = try auth.getSecret(token: token!)

                if modelToken != nil {

                    let security = OpenbuildSingleton.Manager.getSecurity()

                    guard var claimSet = try security.JWTDecode(secret: modelToken!.secret, encodedToken: modelToken!.token) else {
                        return nil
                    }

                    if security.JWTValidate(claimSet: claimSet, audience: security.getDefaultAudience(), claims: security.getDefaultClaims()) == false {
                        return nil
                    }

                    if claimSet["data"] != nil {

                        var decodedData = claimSet["data"]! as! [String:Any]

                        if decodedData["user"] != nil {

                            let jsonUser = decodedData["user"] as! String

                            do {
                                decodedData["user"] = try jsonUser.jsonDecode()
                            } catch {
                                print("FAILED TO DECODE USER")
                            }
                        }

                        claimSet["data"] = decodedData

                    }

                    return claimSet

                }

            }

        } catch {

            print("Invalid token \(error)")
            return nil

        }

        return nil

    }

    /// Returns bool if the request accepts JSON.
    public var acceptsJSON: Bool {

        if let accept = self.header(.accept) {

            let accepts = accept.characters.split(separators: ",".characters).map(String.init)

            let wild = "*/*"
            let json = "application/json"

            //for (index, value) in accepts.enumerated() {
            for (_, value) in accepts.enumerated() {

                if value.hasPrefix(wild) {
                    return true
                }

                if value.hasPrefix(json) {
                    return true
                }

            }

        }

        return false

    }

    //Return a dictionary of body params
    public var bodyParams: [String:Any]? {

        if let contentType = self.header(.contentType) {

            if contentType == "application/json", let encoded = self.postBodyString {

                do {
                    let decoded = try encoded.jsonDecode() as? [String:Any]
                    return decoded
                } catch {
                    return nil
                    //TODO / FIXME - Throw?
                }

            }

        }


        if(self.postParams.count == 0) {
            return nil
        }

        var params: [String: Any] = [:]

        for(name, value) in self.postParams {
            params[name] = value
        }

        return params

    }

    //Return an array of file uploads
    public var files: [FileUpload]? {

        if let uploads = self.postFileUploads , uploads.count > 0 {

            // Create an array of FileUpload
            var arrayFiles = [FileUpload]()

            for upload in uploads {

                if upload.fileSize != 0 {

                    arrayFiles.append(
                        FileUpload(
                            fieldName: upload.fieldName,
                            contentType: upload.contentType,
                            fileName: upload.fileName,
                            fileSize: upload.fileSize,
                            tmpFileName: upload.tmpFileName
                        )
                    )
                }
            }

            if arrayFiles.count == 0 {
                return nil
            }

            return arrayFiles

        } else {
            return nil
        }

    }

    //FIXME - Hack - Would like to use a static and not use the scratchPad...
    public var validatedRequestData: RequestValidation? {
        set(newValue){
            self.scratchPad["OpenbuildVaidatedRequestData"] = newValue
        }
        get {
            return self.scratchPad["OpenbuildVaidatedRequestData"] as? RequestValidation
        }
    }

}