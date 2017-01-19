import OpenbuildExtensionPerfect

public class ModelRole200Delete: ResponseModel200EntityDeleted, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully deleted the entity.'",
        "deleted": "Deleted object describing the Role entity in it's original state."
    ]

    public init(deleted: ModelRole) {
        super.init(deleted: deleted)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelRole200Delete") {

            return docs

        } else {

            let entity = ModelRole(
                role_id: 1,
                role: "RoleExample"
            )

            let model = ModelRole200Delete(deleted: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelRole200Delete", lines: docs)

            return docs

        }

    }

}

extension ModelRole200Delete: CustomReflectable {

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