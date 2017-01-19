import PerfectLib
import OpenbuildExtensionPerfect

public class ModelCMSMarkdown: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "CMS.CMSMarkdown"

    public var cms_markdown_id: Int?
    public var handle: String?
    public var markdown: String?
    public var html: String?
    public var errors: [String: String] = [:]

    public var descriptions = [
        "cms_markdown_id": "The id of the markdown object",
        "handle": "The unique handle of the markdown object, used in uri calls",
        "markdown": "Markdown",
        "html": "HTML generated from the markdown"
    ]


    public init(dictionary: [String : Any]) {
        self.cms_markdown_id = Int(dictionary["cms_markdown_id"]! as! UInt32)
        self.handle = dictionary["handle"] as? String
        self.markdown = dictionary["markdown"] as? String
        self.html = dictionary["html"] as? String
    }

    public init(cms_markdown_id: Int, handle: String, markdown: String, html: String) {
        self.cms_markdown_id = cms_markdown_id
        self.handle = handle
        self.markdown = markdown
        self.html = html
    }

    public init(cms_markdown_id: String, handle: String, markdown: String, html: String) {
        self.cms_markdown_id = Int(cms_markdown_id)
        self.handle = handle
        self.markdown = markdown
        self.html = html
    }

    public init(handle: String, markdown: String, html: String) {
        self.handle = handle
        self.markdown = markdown
        self.html = html
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelCMSMarkdown.registerName,
            "cms_markdown_id": cms_markdown_id! as Int,
            "handle": handle! as String,
            "markdown": markdown! as String,
            "html": html! as String
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["CMS: ModelCMSMarkdown TODO / FIXME"]
    }

}

extension ModelCMSMarkdown: CustomReflectable {

    open var customMirror: Mirror {
        return Mirror(
            self,
            children: [
                "cms_markdown_id": self.cms_markdown_id,
                "handle": self.handle,
                "markdown": self.markdown,
                "html": self.html
            ],
            displayStyle: Mirror.DisplayStyle.class
        )
    }

}