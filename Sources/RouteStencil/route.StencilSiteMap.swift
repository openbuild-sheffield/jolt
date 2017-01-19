import OpenbuildExtensionPerfect
import OpenbuildSingleton
import OpenbuildRouteRegistry
import PerfectLib
import PerfectHTTP
import RouteCMS
import Stencil

public let handlerRouteStencilSiteMap = {
    (request: HTTPRequest, response: HTTPResponse) in

        let renderer = Renderer(response: response)

        do {

            renderer.setFileSystemPaths(paths: ["./Views/"])

            let repositoryCMSPage = try RepositoryCMSPage()

            if let pages = try repositoryCMSPage.siteMap(name: "https://" + request.serverName) {

                let context = Context(dictionary: ["pages": pages])
                _ = renderer.render(template: "sitemap.xml", context: context, contentType: "application/xml")

            } else {
                renderer.render500(message: "500 - Couldn't load any pages.")
            }

        } catch {
            renderer.render500(message: "500 - Couldn't load pages.")
        }

}

public class RouteStencilSiteMap: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {
        return NamedRoute(
            method: "get",
            uri: "/sitemap.xml",
            handlerRoute: handlerRouteStencilSiteMap
        )
    }

}