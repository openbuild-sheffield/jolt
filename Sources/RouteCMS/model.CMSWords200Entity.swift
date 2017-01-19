import OpenbuildExtensionPerfect

public class ModelCMSWords200Entity: ResponseModel200Entity, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully created/fetched the entity.'",
        "entity": "Object describing the Words entity."
    ]

    public init(entity: ModelCMSWords) {
        super.init(entity: entity)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelCMSWords200Entity") {

            return docs

        } else {

            let entity = ModelCMSWords(
                cms_words_id: 1,
                handle: "test",
                words: "These are some words."
            )
            let model = ModelCMSWords200Entity(entity: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelCMSWords200Entity", lines: docs)

            return docs

        }

    }

}

extension ModelCMSWords200Entity: CustomReflectable {

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