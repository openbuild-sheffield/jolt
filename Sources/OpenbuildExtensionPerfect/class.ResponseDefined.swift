import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

public class ResponseDefined {

    private var response: HTTPResponse?
    private var registeredResponses: [Int: Any] = [:]

    public init(){
        self.registeredResponses[500] = true
    }

    public func setResponse(response: HTTPResponse) {
        self.response = response
    }

    public func register(status: Int){

        self.registeredResponses[status] = true

    }

    public func register(status: Int, model: String){
        self.registeredResponses[status] = model
    }

    public func complete(status: Int, model: DocumentationProtocol) {

        let registeredResponse = self.registeredResponses[status]

        if registeredResponse == nil {

            //FIXME / TODO - ROLLBACK
            self.invalidResponse(status: status, response: self.response!)
            return

        }else if registeredResponse! is String {

//print(String(reflecting: model))
//print(registeredResponse! as! String)
//print(String(describing: type(of: model)))
//print("??????????????")
//print(String(reflecting: model))
//print(String(describing: type(of: model)))
//print(registeredResponse! as! String)
//print(registeredResponseString.contains("." + String(describing: type(of: model))))

            let registeredResponseString = registeredResponse! as! String

            //TODO / FIXME - Why is String(reflecting returning the extending class???
            if registeredResponseString != String(reflecting: model) && registeredResponseString.contains("." + String(describing: type(of: model))) == false {
                //FIXME / TODO - ROLLBACK
                self.invalidResponseModel(model: registeredResponse! as! String, status: status, response: self.response!)
                return
            }

        }

        let jsonModel = model as! JSONConvertibleObject

        print("COMPLETED \(status)")
        print(self.registeredResponses[status] as Any)

        var encoded = ""

        do {

            encoded = try jsonModel.jsonEncodedString()

        } catch {

            print("JSON ENCODE ERROR \(error)")
            encoded = "{\"error\": true}"

        }

        let response = self.response!

        response.setHeader(.contentType, value: "application/json")

        switch status {

            case 200:
                response.status = .ok

            case 400:
                response.status = .badRequest

            case 403:
                response.status = .forbidden

            case 404:
                response.status = .notFound

            case 422:
                response.status = HTTPResponseStatus.custom(code: 422, message: "Unprocessable Entity")

            case 500:
                response.status = .internalServerError

            default:
                //FIXME
                print("Invalid status code")

        }

        response.appendBody(string: encoded)

        response.completed()

    }

    private func invalidResponse(status: Int, response: HTTPResponse) {

        response.setHeader(.contentType, value: "application/json")
        response.status = .internalServerError

        let jsonModel = ResponseModel500Messages(messages: [
            "error": "Status code not registered for response.",
            "uri": response.request.uri,
            "method": response.request.method.description
        ])

        var encoded = ""

        do {

            encoded = try jsonModel.jsonEncodedString()

        } catch {

            print("JSON ENCODE ERROR \(error)")
            encoded = "{\"error\": true}"

        }

        response.appendBody(string: encoded)
        response.completed()

    }

    private func invalidResponseModel(model: String, status: Int, response: HTTPResponse) {

        response.setHeader(.contentType, value: "application/json")
        response.status = .internalServerError

        let jsonModel = ResponseModel500Messages(messages: [
            "error": "Invalid model used in response.",
            "uri": response.request.uri,
            "method": response.request.method.description,
            "expected": model
        ])

        var encoded = ""

        do {

            encoded = try jsonModel.jsonEncodedString()

        } catch {

            print("JSON ENCODE ERROR \(error)")
            encoded = "{\"error\": true}"

        }

        response.appendBody(string: encoded)
        response.completed()

    }

    public func describeRAML() -> [String] {

        var raml = ["    responses:"]

        for (status, value) in self.registeredResponses.sorted(by: {$0.key < $1.key}) {

            raml.append("      \(status):")

            if value is String {

                let doc = FactoryRamlDoc.getDocumentation(name: value as! String)

                if doc != nil {

                    for line in doc! {
                        raml.append("        " + line)
                    }

                }

            } else {
                raml.append("        body: Response\(status)")
            }

        }

        return raml

    }

}