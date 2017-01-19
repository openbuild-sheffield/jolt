import OpenbuildExtensionPerfect
import OpenbuildSingleton
import OpenbuildRouteRegistry
import PerfectLib
import PerfectHTTP
import RouteCMS
import Stencil
import PathKit

public let handlerRouteStencilCMS = {
    (request: HTTPRequest, response: HTTPResponse) in

        var path = request.path

        if path[path.index(before: path.endIndex)] == "/" {
            path.append("index.html") // FIXME needs to be configurable
        }

        let file = File(request.documentRoot + "/" + path)

        if file.exists {

            StaticFileHandler(documentRoot: request.documentRoot).handleRequest(request: request, response: response)

        } else {

            let renderer = Renderer(response: response)

            do {

                let themePath = Path(OpenbuildSingleton.Manager.getThemePath() + "/")

                renderer.setFileSystemPaths(paths: [themePath, "./Views/"])

                let repositoryCMSPage = try RepositoryCMSPage()

                if let page = try repositoryCMSPage.getByPath(path: request.path) {

                    let context = Context(dictionary: page.getValues())
                    _ = renderer.render(template: page.template_path!, context: context, contentType: "text/html")

                } else {
                    renderer.render404(message: "Couldn't find \(request.path)")
                }

            } catch {

                renderer.render500(message: "500 - Couldn't load page.")

            }
            response.appendBody(string: "TODO CMS")
            response.completed()
        }

}

public class RouteStencilCMSHome: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {
        return NamedRoute(
            method: "get",
            uri: "/",
            handlerRoute: handlerRouteStencilCMS
        )
    }

}

public class RouteStencilCMS: OpenbuildRouteRegistry.FactoryRoute {

    override public func route() -> NamedRoute? {
        return NamedRoute(
            method: "get",
            uri: "/**",
            handlerRoute: handlerRouteStencilCMS
        )
    }

}