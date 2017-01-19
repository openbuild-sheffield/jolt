import OpenbuildExtensionPerfect

public class ModelCMSWords200Update: ResponseModel200EntityUpdated, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully updated the entity.'",
        "old": "Object describing the Words entity in it's original state.",
        "updated": "Object describing the Words entity in it's updated state."
    ]

    public init(old: ModelCMSWords, updated: ModelCMSWords) {
        super.init(old: old, updated: updated)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSWords200Update") {

            return docs

        } else {

            let entityOld = ModelCMSWords(
                cms_words_id: 1,
                handle: "test",
                words: "These are some words."
            )

            let entityUpdated = ModelCMSWords(
                cms_words_id: 1,
                handle: "test",
                words: "These are some updated words."
            )

            let model = ModelCMSWords200Update(old: entityOld, updated: entityUpdated)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSWords200Update", lines: docs)

            return docs

        }

    }

}

extension ModelCMSWords200Update: CustomReflectable {

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