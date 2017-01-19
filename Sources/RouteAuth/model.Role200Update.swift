import OpenbuildExtensionPerfect

public class ModelRole200Update: ResponseModel200EntityUpdated, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully updated the entity.'",
        "old": "Object describing the Role entity in it's original state.",
        "updated": "Object describing the Role entity in it's updated state."
    ]

    public init(old: ModelRole, updated: ModelRole) {
        super.init(old: old, updated: updated)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelRole200Update") {

            return docs

        } else {

            let entityOld = ModelRole(
                role_id: 1,
                role: "RoleExample"
            )

            let entityUpdated = ModelRole(
                role_id: 1,
                role: "RoleExampleUpdated"
            )

            let model = ModelRole200Update(old: entityOld, updated: entityUpdated)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelRole200Update", lines: docs)

            return docs

        }

    }

}

extension ModelRole200Update: CustomReflectable {

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