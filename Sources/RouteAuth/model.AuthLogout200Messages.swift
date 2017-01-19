import PerfectLib
import OpenbuildExtensionPerfect

public class ModelAuthLogout200Messages: ResponseModel200Messages, DocumentationProtocol {

    static let registerName = "Auth.AuthLogout200Messages"

    public override func getRegisteredName() ->  String{
        return ModelAuthLogout200Messages.registerName
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelAuthLogout200Messages") {

            return docs

        } else {

            let model = ModelAuthLogout200Messages(messages: [
                "logged_out": true,
                "message": "You have logged out of the system."
            ])
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelAuthLogout200Messages", lines: docs)

            return docs

        }

    }

}