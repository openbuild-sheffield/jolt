import OpenbuildExtensionPerfect

public class ModelRole200Entity: ResponseModel200Entity, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully created/fetched the entity.'",
        "entity": "Object describing the role."
    ]

    public init(entity: ModelRole) {
        super.init(entity: entity)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelRole200Entity") {

            return docs

        } else {

            let entity = ModelRole(role_id: 1, role: "RoleExample")
            let model = ModelRole200Entity(entity: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelRole200Entity", lines: docs)

            return docs

        }

    }

}

extension ModelRole200Entity: CustomReflectable {

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