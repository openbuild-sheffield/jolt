import OpenbuildExtensionPerfect

public class ModelCMSWords200Delete: ResponseModel200EntityDeleted, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully deleted the entity.'",
        "deleted": "Deleted object describing the Words entity in it's original state."
    ]

    public init(deleted: ModelCMSWords) {
        super.init(deleted: deleted)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSWords200Delete") {

            return docs

        } else {

            let entity = ModelCMSWords(
                cms_words_id: 1,
                handle: "test",
                words: "These are some words."
            )

            let model = ModelCMSWords200Delete(deleted: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSWords200Delete", lines: docs)

            return docs

        }

    }

}

extension ModelCMSWords200Delete: CustomReflectable {

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