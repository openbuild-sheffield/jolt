import OpenbuildExtensionPerfect

public class ModelCMSMarkdown200Delete: ResponseModel200EntityDeleted, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully deleted the entity.'",
        "deleted": "Deleted object describing the Markdown entity in it's original state."
    ]

    public init(deleted: ModelCMSMarkdown) {
        super.init(deleted: deleted)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSMarkdown200Delete") {

            return docs

        } else {

            let entity = ModelCMSMarkdown(
                cms_markdown_id: 1,
                handle: "test",
                markdown: "#Markdown",
                html: "<h1>Markdown</h1>"
            )
            let model = ModelCMSMarkdown200Delete(deleted: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSMarkdown200Delete", lines: docs)

            return docs

        }

    }

}

extension ModelCMSMarkdown200Delete: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "deleted": self.deleted
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}