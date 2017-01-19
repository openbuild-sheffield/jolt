import OpenbuildExtensionPerfect

public class ModelUser200Entities: ResponseModel200Entities, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully fetched the entities.'",
        "entities": "Object describing the users."
    ]

    public init(entities: ModelUsersPlainMin) {
        super.init(entities: entities)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelUser200Entities") {

            return docs

        } else {

            let entities = ModelUsersPlainMin(users: [])

            var rolesAdmin = [[String:Any]]()
            var rolesEditor = [[String:Any]]()

            let roleAdmin = ["role_id": UInt32(1), "role": "Admin"] as [String : Any]
            let roleEditor = ["role_id": UInt32(2), "role": "Editor"] as [String : Any]

            rolesAdmin.append(roleAdmin)
            rolesAdmin.append(roleEditor)

            rolesEditor.append(roleEditor)

            entities.addUser(
                ModelUserPlainMin(
                    user_id: 1,
                    username: "admin",
                    email: "admin@test.com",
                    passwordUpdate: false,
                    created: "2016-12-25 17:56:31",
                    roles: rolesAdmin
                )
            )

            entities.addUser(
                ModelUserPlainMin(
                    user_id: 2,
                    username: "editor",
                    email: "editor@test.com",
                    passwordUpdate: false,
                    created: "2016-12-25 17:57:51",
                    roles: rolesEditor
                )
            )

            let model = ModelUser200Entities(entities: entities)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelUser200Entities", lines: docs)

            return docs

        }

    }

}

extension ModelUser200Entities: CustomReflectable {

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