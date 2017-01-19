import PerfectLib
import PerfectHTTP

public func GetRequestValidation(request: HTTPRequest) -> RequestValidation {

    var raw: [String: Any] = [:]

    raw["token"] = request.decodedToken
    raw["uri"] = request.urlVariables
    raw["body"] = request.bodyParams
    raw["files"] = request.files

    return RequestValidation(raw: raw)

}