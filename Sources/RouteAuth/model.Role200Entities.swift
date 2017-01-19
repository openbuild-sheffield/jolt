import OpenbuildExtensionPerfect

public class ModelRole200Entities: ResponseModel200Entities, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully fetched the entities.'",
        "entities": "Object describing the roles."
    ]

    public init(entities: ModelRoles) {
        super.init(entities: entities)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelRole200Entities") {

            return docs

        } else {

            let entities = ModelRoles()
            entities.addRole(ModelRole(role_id: 1, role: "RoleExample"))
            entities.addRole(ModelRole(role_id: 2, role: "RoleAnotherExample"))

            let model = ModelRole200Entities(entities: entities)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelRole200Entities", lines: docs)

            return docs

        }

    }

}

extension ModelRole200Entities: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "error": self.error,
                "message": self.message,
                "entities": self.entities
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}