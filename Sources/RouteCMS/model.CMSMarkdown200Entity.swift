import OpenbuildExtensionPerfect

public class ModelCMSMarkdown200Entity: ResponseModel200Entity, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully created/fetched the entity.'",
        "entity": "Object describing the Markdown entity."
    ]

    public init(entity: ModelCMSMarkdown) {
        super.init(entity: entity)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSMarkdown200Entity") {

            return docs

        } else {

            let entity = ModelCMSMarkdown(
                cms_markdown_id: 1,
                handle: "test",
                markdown: "#Markdown",
                html: "<h1>Markdown</h1>"
            )
            let model = ModelCMSMarkdown200Entity(entity: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSMarkdown200Entity", lines: docs)

            return docs

        }

    }

}

extension ModelCMSMarkdown200Entity: CustomReflectable {

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