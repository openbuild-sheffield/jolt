import OpenbuildExtensionPerfect

public class ModelCMSMarkdown200Update: ResponseModel200EntityUpdated, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully updated the entity.'",
        "old": "Object describing the Markdown entity in it's original state.",
        "updated": "Object describing the Markdown entity in it's updated state."
    ]

    public init(old: ModelCMSMarkdown, updated: ModelCMSMarkdown) {
        super.init(old: old, updated: updated)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSMarkdown200Update") {

            return docs

        } else {

            let entityOld = ModelCMSMarkdown(
                cms_markdown_id: 1,
                handle: "test",
                markdown: "#Markdown",
                html: "<h1>Markdown</h1>"
            )

            let entityUpdated = ModelCMSMarkdown(
                cms_markdown_id: 1,
                handle: "test",
                markdown: "#Markdown updated",
                html: "<h1>Markdown updated</h1>"
            )

            let model = ModelCMSMarkdown200Update(old: entityOld, updated: entityUpdated)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSMarkdown200Update", lines: docs)

            return docs

        }

    }

}

extension ModelCMSMarkdown200Update: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "old": self.old,
                "updated": self.updated
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}