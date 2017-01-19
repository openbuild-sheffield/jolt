import PerfectLib
import OpenbuildExtensionPerfect

public class ModelToken: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "Auth.Token"

    public var token: String

    public var descriptions = [
        "token": "Token to be send as a header with future requests."
    ]

    public init(token: String) {
        self.token = token
    }

    public override func setJSONValues(_ values: [String : Any]) {
        self.token = getJSONValue(named: "token", from: values, defaultValue: "")
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelToken.registerName,
            "token":token,
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "ModelToken") {

            return docs

        } else {

            let model = ModelToken(token: "eyJhbGciOiJDUzUxMiIsInR7cCI6IkpXVCJ9.eyJhdWQiOiJ5ZXN0QXVkaWVuY2UiLCJkYXRhIjp7InVzZXEiOiJ7XCJfanNvbm9iamlkXCI6XCJBdXRoLlVzZXJQbGFpblwiLFwiZW8haWxcIjpcImRhbm55bGV3aXMuc2hlZmZpZWxtQGdvb2dsZW1haWwuY29tXCIsXCJjcmVhdGVkXCI6XCIrMDE2LTEyLTAyIDE3OjU2OjMxXCIsXCJyb2xlc1wiOlt7XCJyb2xlXCI6XCJBZG1pblwiLFwiX2pzb25vYmppZFwiOlwiQXV0aC5Sb2xlXCIsXCJyb2xlX2lkXCI6MX0se1wicm9sZVwiOlwiRWRpdG9yXCIsXCJfanNvbm9iamlkXCI6XCJBdXRoLlJvbGVcIixcInJvbGVfaWRcIjoyfV0sXCJwYXNzd29yZFwiOlwiNzViNTB0NDRhNjMxZWJmY2I3OWQzNjQ1YmZlMzk5MzljMWI4MzdlZGY3Y2NiNGJmY2RlYWJkOWFkMmIzZGJhM2Y2OTExZjViNDZkM2NiNGExMGM0N2Y3OWQwOWYxM2Q4ZjE0OJRkY2VjMDU1MTQxNDkzMjU0ZjdhMzQ3YWQzMWZcIixcInNlY3JldFwiOlwiV2J4U2pGWmFQYUROeFpmTlhwdkg2cFd2U0xBck1PdTdFZUlteUFtQ1BYSHNoQ0JrOWphb3Q4ZWFlMnlwZFhn0VhJVWV1eldKdE5TQ0E5cWx2d2FPdnBPS1JpVzUzSlM0RnJHVzlBSmp3N3ZsQnJ1d2J0N2tUeFlnNlVJaTlUcnRcIixcInVzZXJfaWRcIjoxLFwidXNlcm5hbWVcIjpcImFHbWluXCIsXCJwYXNzd29yZFVwZGF0ZVwiOmZhbHNlfSJ9LCJmdSI6ImJhciIsImlzcyI6Im9wZW5idWlsZC5zaGVmZmllbGQiLCJpYXQiOjE0ODE1NDM3MjkuMzIyNzk3LCJib2IiOiJiYXoiLCJleHAiOjE0ODE1NDczMjkuMzIyODIxLCJuYmYiOjE0ODE1NGM3MjkuMzIyODI2fQ.f6RlFU5LXDn2cqq_IKnp1QeAOwgGYaTYkDLsqdSSroTvh3DRwkb_9r0bviHafl4VjYH7jjzwOjCvfy0Izis1Cw")
            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "ModelToken", lines: docs)

            return docs

        }

    }

}

extension ModelToken: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "token": self.token
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}