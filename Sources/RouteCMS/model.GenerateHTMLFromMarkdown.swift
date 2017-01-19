import PerfectLib
import OpenbuildExtensionPerfect

public class ModelGenerateHTMLFromMarkdown: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "CMS.GenerateHTMLFromMarkdown"

    public var markdown: String
    public var html: String

    public var descriptions = [
        "markdown": "The markdown sent to the server.",
        "html": "HTML generated from the markdown."
    ]

    public init(markdown: String, html: String) {
        self.markdown = markdown
        self.html = html
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelGenerateHTMLFromMarkdown.registerName,
            "markdown":markdown,
            "html":html
        ]
    }

    public static func describeRAML() -> [String] {

        if let docs = ResponseDocumentation.getRAML(key: "RouteCMS.ModelGenerateHTMLFromMarkdown") {

            return docs

        } else {

            let model = ModelGenerateHTMLFromMarkdown(
                markdown: "#Markdown",
                html: "<h1>Markdown</h1>"
            )

            let aMirror = Mirror(reflecting: model)
            let docs = ResponseDocumentation.genRAML(mirror: aMirror, descriptions: model.descriptions)

            ResponseDocumentation.setRAML(key: "RouteCMS.ModelGenerateHTMLFromMarkdown", lines: docs)

            return docs

        }

    }

}

extension ModelGenerateHTMLFromMarkdown: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "markdown": self.markdown,
                "html": self.html
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}