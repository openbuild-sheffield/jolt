import OpenbuildExtensionPerfect

public class ModelUser200Entity: ResponseModel200Entity, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully created/fetched the entity.'",
        "entity": "Object describing the user."
    ]

    public init(entity: ModelUserPlainMin) {
        super.init(entity: entity)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelUser200Entity") {

            return docs

        } else {

            var rolesAdmin = [[String:Any]]()

            let roleAdmin = ["role_id": UInt32(1), "role": "Admin"] as [String : Any]
            let roleEditor = ["role_id": UInt32(2), "role": "Editor"] as [String : Any]

            rolesAdmin.append(roleAdmin)
            rolesAdmin.append(roleEditor)

            let entity = ModelUserPlainMin(
                user_id: 1,
                username: "admin",
                email: "admin@test.com",
                passwordUpdate: false,
                created: "2016-12-25 17:56:31",
                roles: rolesAdmin
            )

            let model = ModelUser200Entity(entity: entity)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelUser200Entity", lines: docs)

            return docs

        }

    }

}

extension ModelUser200Entity: CustomReflectable {

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