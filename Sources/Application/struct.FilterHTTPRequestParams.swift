import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import OpenbuildExtensionPerfect
import OpenbuildRouteRegistry

struct FilterHTTPRequestParams: HTTPRequestFilter {

    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {

        let handlerRequest = RouteRegistry.getHandlerRequest(uri: request.path.lowercased(), method: request.method)

        if handlerRequest != nil {

            //HACK - We need to do this here or urlVariables is not populated
            _ = routes.navigator.findHandler(uri: request.path, webRequest: request)!

            let results = handlerRequest!.validate(request: request)
            print("validationResults: \(results)")

            if results.valid {

                request.validatedRequestData = results
                callback(.continue(request, response))

            } else {

                if results.permissionErrors.isEmpty {

                    let doResponse = ResponseDefined()
                    doResponse.register(status: 400)
                    doResponse.setResponse(response: response)
                    doResponse.complete(status: 400, model: ResponseModel400(validation: results))

                } else {

                    let doResponse = ResponseDefined()
                    doResponse.register(status: 403)
                    doResponse.setResponse(response: response)
                    doResponse.complete(status: 403, model: ResponseModel403(validation: results))

                }

                callback(.halt(request, response))
            }

        } else {

            callback(.continue(request, response))

        }

    }

}
