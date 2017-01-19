import Foundation
import PerfectLib
import PerfectHTTP
import OpenbuildExtensionPerfect

open class RouteRegistry {

    private static var routes: [String: NamedRoute] = [:]
    private static var routeMap: [String: MapRoute] = [:]

    public static func getRoute(namedRoute: String) -> NamedRoute? {

        if self.routes[namedRoute] != nil {
            return self.routes[namedRoute]
        }

        guard let factory = OpenbuildRouteRegistry.FactoryRoute.create(name: namedRoute) else {
            return nil
        }

        guard let route = factory.route() else {
            return nil
        }

        self.routes[namedRoute] = route

        return self.routes[namedRoute]

    }

    public static func addRouteMap(key: String, method: String, uri: String){
        self.routeMap[key] = MapRoute(
            method: HTTPMethod.fromString(method: method),
            uri: uri
        )
    }

    public static func getRoutes() -> [String: NamedRoute] {
        return self.routes
    }

    public static func getRouteMap() -> [String: MapRoute] {
        return self.routeMap
    }

    public static func getRouteKey(uri: String, method: HTTPMethod) -> String? {

        var realUri = uri

        if realUri.characters.last! == "/" && realUri.characters.count != 1{
            realUri.remove(at: realUri.index(before: realUri.endIndex))
        }

        for (index, value) in self.routeMap {

            if value.method == method {

                //Check if it's just a straight match
                if realUri == value.uri {
                    return index
                }

                //Check parts
                let realUriArray : [String] = realUri.components(separatedBy: "/")
                let routeUriArray : [String] = value.uri.components(separatedBy: "/")

                if realUriArray.count == routeUriArray.count {

                    var matched = true

                    for (k, _) in realUriArray.enumerated() {

                        if realUriArray[k] != routeUriArray[k] {

                            let first = routeUriArray[k].characters.first
                            let last = routeUriArray[k].characters.last

                            if first != nil && last != nil {
                                if first! != "{" || last! != "}" {
                                    matched = false
                                }
                            }

                        }

                    }

                    if matched {
                        return index
                    }

                }

            }

        }

        return nil

    }

    public static func getHandlerRequest(uri: String, method: HTTPMethod) -> RequestProtocol? {

        let routeKey = self.getRouteKey(uri: uri, method: method)

        if routeKey == nil {
            return nil
        }

        let route = self.getRoute(namedRoute: routeKey!)

        if route == nil {
            return nil
        }

        let handlerRequest: RequestProtocol? = route!.handlerRequest

        if handlerRequest != nil {
            return handlerRequest!
        } else {
            return nil
        }

    }

    public static func getHandlerResponse(uri: String, method: HTTPMethod, response: HTTPResponse) -> ResponseDefined? {

        let routeKey = self.getRouteKey(uri: uri, method: method)

        if routeKey == nil {
            self.noRoute(uri: uri, method: method, response: response)
            return nil
        }

        let route = self.getRoute(namedRoute: routeKey!)

        if route == nil {
            self.noRoute(uri: uri, method: method, response: response)
            return nil
        }

        let handlerResponse: ResponseDefined? = route!.handlerResponse

        if handlerResponse != nil {
            handlerResponse!.setResponse(response: response)
            return handlerResponse!
        } else {
            self.noResponseHandler(response: response)
            return nil
        }

    }

    public static func getHandlerResponse(uri: String, method: HTTPMethod) -> ResponseDefined? {

        let routeKey = self.getRouteKey(uri: uri, method: method)

        if routeKey == nil {
            return nil
        }

        let route = self.getRoute(namedRoute: routeKey!)

        if route == nil {
            return nil
        }

        let handlerResponse: ResponseDefined? = route!.handlerResponse

        if handlerResponse != nil {
            return handlerResponse!
        } else {
            return nil
        }

    }

    private static func noRoute(uri: String, method: HTTPMethod, response: HTTPResponse){
        let doResponse = ResponseDefined()
        doResponse.register(status: 404)
        doResponse.setResponse(response: response)
        doResponse.complete(status: 404, model: ResponseModel404(uri: uri, method: method.description))
    }

    private static func noResponseHandler(response: HTTPResponse){
        let doResponse = ResponseDefined()
        doResponse.register(status: 500)
        doResponse.setResponse(response: response)
        doResponse.complete(status: 500, model: ResponseModel500NoResponseHandler())
    }

}