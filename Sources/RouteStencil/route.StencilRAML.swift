import OpenbuildExtensionPerfect
import OpenbuildSingleton
import OpenbuildRouteRegistry
import PerfectLib
import PerfectHTTP
import RouteCMS
import Stencil

private struct ramlCache {

    private static var cache: String?

    static func get() -> String? {

        if let data = self.cache {
            return data
        } else {
            return nil
        }

    }

    static func set(content: String) {
        self.cache = content
    }

    static func delete() {
        self.cache = nil
    }

}

public let handlerRouteStencilRAML = {
    (request: HTTPRequest, response: HTTPResponse) in

        let cached = ramlCache.get()

        if cached != nil {

            response.setHeader(.contentType, value: "application/raml+yaml")

            response.appendBody(string: cached!)
            response.completed()

            return

        }

        struct genericRaml {var name: String; var docs: [String];}
        struct routeRaml {var method: String; var docs: [String];}
        struct routeUri {var uri: String; var methods: [routeRaml]}

        let renderer = Renderer(response: response)
        renderer.setFileSystemPaths(paths: ["./Views/"])

        var URIMap:[String:[routeRaml]] = [:]

        for (_, map) in RouteRegistry.getRouteMap().sorted(by: {$0.value.uri < $1.value.uri}) {

            let handlerRequest = RouteRegistry.getHandlerRequest(uri: map.uri.lowercased(), method: map.method)
            let handlerResponse = RouteRegistry.getHandlerResponse(uri: map.uri.lowercased(), method: map.method)

            if handlerRequest != nil && handlerResponse != nil {

                let docsRequest = handlerRequest!.getDocumentation(handlerResponse: handlerResponse!)
                let docs = docsRequest.asRaml(description: handlerRequest!.description)

                if URIMap[map.uri] == nil {
                    URIMap[map.uri] = [routeRaml(method: map.method.description, docs: docs)]
                } else {
                    URIMap[map.uri]!.append(routeRaml(method: map.method.description, docs: docs))
                }

            }

        }

        //Flatten the structure so it can be used by the template
        var uris = [routeUri]()

        for (uri, data) in URIMap.sorted(by: { $0.0 < $1.0 }) {
            uris.append(routeUri(uri:uri, methods: data))
        }

        let context = Context(dictionary: [
            "generic": [
                genericRaml(name: "Response400", docs: ResponseModel400Messages.describeRAML()),
                genericRaml(name: "Response403", docs: ResponseModel403.describeRAML()),
                genericRaml(name: "Response404", docs: ResponseModel404.describeRAML()),
                genericRaml(name: "Response422", docs: ResponseModel422.describeRAML()),
                genericRaml(name: "Response500", docs: ResponseModel500Messages.describeRAML())
            ],
            "uris": uris
        ])

        let content = renderer.render(template: "api.raml", context: context, contentType: "application/raml+yaml")

        if content != nil {
            ramlCache.set(content: content!)
        }

}

public class RouteStencilRAML: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {
        return NamedRoute(
            method: "get",
            uri: "/api.raml",
            handlerRoute: handlerRouteStencilRAML
        )
    }

}