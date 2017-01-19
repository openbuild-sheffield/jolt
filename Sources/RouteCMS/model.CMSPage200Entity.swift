import OpenbuildExtensionPerfect

public class ModelCMSPage200Entity: ResponseModel200Entity, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully created/fetched the entity.'",
        "entity": "Object describing the Page entity."
    ]

    public init(entity: ModelCMSPage) {
        super.init(entity: entity)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSPage200Entity") {

            return docs

        } else {

            let entity = ModelCMSPage(
                cms_page_id: 1,
                uri: "/",
                template_path: "page.html",
                title: "Home page",
                description: "Home page meta description",
                variables: []
            )
            let model = ModelCMSPage200Entity(entity: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSPage200Entity", lines: docs)

            return docs

        }

    }

}

extension ModelCMSPage200Entity: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "entity": self.entity
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}