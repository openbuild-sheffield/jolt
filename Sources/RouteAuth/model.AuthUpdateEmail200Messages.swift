import PerfectLib
import OpenbuildExtensionPerfect

public class ModelAuthUpdateEmail200Messages: ResponseModel200Messages, DocumentationProtocol {

    static let registerName = "Auth.AuthUpdatePassword200Messages"

    public override func getRegisteredName() ->  String{
        return ModelAuthUpdateEmail200Messages.registerName
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelAuthUpdateEmail200Messages") {

            return docs

        } else {

            let model = ModelAuthUpdateEmail200Messages(messages: [
                "updated": true,
                "message": "User email has been updated."
            ])
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelAuthUpdateEmail200Messages", lines: docs)

            return docs

        }

    }

}