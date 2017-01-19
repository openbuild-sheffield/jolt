public class RequestDocumentation{

    private var method: String
    private var uri: String
    private var validation: RequestValidation
    private var handlerResponse: ResponseDefined

    public init(method: String, uri: String, validation: RequestValidation, handlerResponse: ResponseDefined) {
        self.method = method
        self.uri = uri
        self.validation = validation
        self.handlerResponse = handlerResponse
    }

    public func asRaml(description: String) -> [String] {

        var raml = ["  \(self.method):"]
        raml.append("    description: \(description)")

        var uriParameters = false

        for validator in self.validation.validators {

            if validator.validationType == "uri"{

                if uriParameters == false {
                    raml.append("    uriParameters:")
                    uriParameters = true
                }

                raml.append("      " + validator.name + ":")

                let v = validator.validator

                for descriptor in v.describeRAML() {
                    raml.append("        " + descriptor)
                }

            }

        }

        var bodyParameters = false

        for validator in self.validation.validators {

            if validator.validationType == "body"{

                if bodyParameters == false {
                    raml.append("    body:")
                    bodyParameters = true
                }

                raml.append("      " + validator.name)

                let v = validator.validator

                for descriptor in v.describeRAML() {
                    raml.append("        " + descriptor)
                }

            }

        }

        for line in self.handlerResponse.describeRAML() {
            raml.append(line)
        }

        return raml

    }

}