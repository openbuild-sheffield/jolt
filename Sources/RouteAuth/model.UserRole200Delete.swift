import OpenbuildExtensionPerfect

public class ModelUserRole200Delete: ResponseModel200EntityUpdated, DocumentationProtocol {

    public var descriptions = [
        "error": "An error has occurred, will always be false",
        "message": "Will always be 'Successfully updated the entity.'",
        "old": "Object describing the User entity in it's original state.",
        "updated": "Object describing the User entity in it's updated state."
    ]

    public init(old: ModelUserPlainMin, updated: ModelUserPlainMin) {
        super.init(old: old, updated: updated)
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteAuth.ModelUserRole200Delete") {

            return docs

        } else {

            var rolesAdmin = [[String:Any]]()
            var rolesAdminUpdated = [[String:Any]]()

            let roleAdmin = ["role_id": UInt32(1), "role": "Admin"] as [String : Any]
            let roleEditor = ["role_id": UInt32(2), "role": "Editor"] as [String : Any]
            let roleTester = ["role_id": UInt32(3), "role": "Tester"] as [String : Any]

            rolesAdmin.append(roleAdmin)
            rolesAdmin.append(roleEditor)
            rolesAdmin.append(roleTester)

            rolesAdminUpdated.append(roleAdmin)
            rolesAdminUpdated.append(roleEditor)

            let entityOld = ModelUserPlainMin(
                user_id: 1,
                username: "admin",
                email: "admin@test.com",
                passwordUpdate: false,
                created: "2016-12-25 17:56:31",
                roles: rolesAdmin
            )

            let entityUpdated = ModelUserPlainMin(
                user_id: 1,
                username: "admin",
                email: "admin@test.com",
                passwordUpdate: false,
                created: "2016-12-25 17:56:31",
                roles: rolesAdminUpdated
            )

            let model = ModelUserRole200Delete(old: entityOld, updated: entityUpdated)
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteAuth.ModelUserRole200Delete", lines: docs)

            return docs

        }

    }

}

extension ModelUserRole200Delete: CustomReflectable {

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