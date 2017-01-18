import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

struct FilterHTTPStatusCode404: HTTPResponseFilter {

    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }

    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {


        response.setHeader(.custom(name: "Powered-By"), value: "Openbuild (Sheffield) LTD")

        if let token = response.request.decodedToken {
            response.setHeader(
                .custom(name: "Token-Expires-Seconds"),
                value: String(Int(token["exp"] as! Double - Date().timeIntervalSince1970))
            )
        }


        var isJsonResponse = false

        for (index, value) in response.headers {

            if HTTPResponseHeader.Name.contentType == index && value == "application/json" {
                isJsonResponse = true
            }

        }

        if isJsonResponse {

            callback(.continue)

        } else {

            if case .notFound = response.status {
                callback(.done)
            } else {
                callback(.continue)
            }

        }

    }

}