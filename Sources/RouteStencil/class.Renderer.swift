import Foundation
import PerfectLib
import PerfectHTTP
import Stencil
import PathKit

public class Renderer {

    private var response: HTTPResponse
    private var fileSystemPaths: [Path]?

    public init(response: HTTPResponse){
        self.response = response
    }

    public func setFileSystemPaths(paths: [Path]){
        self.fileSystemPaths = paths
    }

    public func render(template: String, context: Context, contentType: String) -> String? {

        do {

            let fsLoader = FileSystemLoader(paths: self.fileSystemPaths!)
            let loadedTemplate = try fsLoader.loadTemplate(name: template)

            if loadedTemplate == nil {

                self.render500(message: "Failed to load template \(template)")

            } else {

                let content = try loadedTemplate!.render(context)

                self.response.setHeader(.contentType, value: contentType)

                self.response.appendBody(string: content)
                self.response.completed()

                return content

            }

        } catch {
            self.render500(message: "Failed to render template \(template)")
        }

        return nil

    }

    public func render404(message: String){

        do {

            let fsLoader = FileSystemLoader(paths: self.fileSystemPaths!)
            let loadedTemplate = try fsLoader.loadTemplate(name: "404.html")

            if loadedTemplate == nil {
                self.render500(message: "Failed to load template 404.html")
            } else {

                let context = Context(dictionary: ["message": message])

                let content = try loadedTemplate!.render(context)

                self.response.setHeader(.contentType, value: "text/html")
                self.response.status = .notFound
                self.response.appendBody(string: content)
                self.response.completed()

            }

        } catch {
            self.render500(message: "Failed to render template 404.html")
        }

    }

    public func render500(message: String){

        do {

            let fsLoader = FileSystemLoader(paths: self.fileSystemPaths!)
            let loadedTemplate = try fsLoader.loadTemplate(name: "500.html")

            if loadedTemplate == nil {

                self.response.status = .internalServerError
                self.response.appendBody(string: message)
                self.response.completed()

            } else {

                let context = Context(dictionary: ["message": message])

                let content = try loadedTemplate!.render(context)

                self.response.setHeader(.contentType, value: "text/html")
                self.response.status = .internalServerError
                self.response.appendBody(string: content)
                self.response.completed()

            }

        } catch {

            self.response.status = .internalServerError
            self.response.appendBody(string: message)
            self.response.completed()

        }

    }
}