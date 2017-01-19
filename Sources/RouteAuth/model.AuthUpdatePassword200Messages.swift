import PerfectLib
import OpenbuildExtensionPerfect

public class ModelAuthUpdatePassword200Messages: ResponseModel200Messages, DocumentationProtocol {

    static let registerName = "Auth.AuthLogout200Messages"

    public override func getRegisteredName() ->  String{
        return ModelAuthUpdatePassword200Messages.registerName
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelAuthUpdatePassword200Messages") {

            return docs

        } else {

            let model = ModelAuthUpdatePassword200Messages(messages: [
                "updated": true,
                "message": "User password has been updated."
            ])
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelAuthUpdatePassword200Messages", lines: docs)

            return docs

        }

    }

}