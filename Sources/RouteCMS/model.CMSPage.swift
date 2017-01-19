import PerfectLib

public class ModelCMSPage: JSONConvertibleObject {

    static let registerName = "CMS.CMSPage"

    public var cms_page_id: Int?
    public var uri: String?
    public var template_path: String? = "page.html"
    public var title: String? = "Title not set"
    public var description: String? = "Description not set"

    private var variables: [String:Any]
    public var variablesCreate: [Any]

    public var errors: [String: String] = [:]


    //DB
    public init(dictionary: [String : Any]) {
        self.cms_page_id = Int(dictionary["cms_page_id"]! as! UInt32)
        self.uri = dictionary["uri"] as? String
        self.template_path = dictionary["template_path"] as? String
        self.title = dictionary["title"] as? String
        self.description = dictionary["description"]! as? String
        self.variables = dictionary["variables"]! as! [String: Any]
        self.variablesCreate = []
    }

    //Used for create
    public init(uri: String, template_path: String, title: String, description: String, variables: [Any]){
        self.uri = uri
        self.template_path = template_path
        self.title = title
        self.description = description
        self.variables = [:]
        self.variablesCreate = variables
    }

    //Used for docs
    public init(cms_page_id: Int, uri: String, template_path: String, title: String, description: String, variables: [Any]){
        self.cms_page_id = cms_page_id
        self.uri = uri
        self.template_path = template_path
        self.title = title
        self.description = description
        self.variables = [:]
        self.variablesCreate = variables
    }

    public func getValues() -> [String: Any]{

        var returnValues = self.variables

        returnValues["page_title"] = self.title
        returnValues["page_description"] = self.description

        return returnValues

    }

    public override func getJSONValues() -> [String : Any] {

        return [
            JSONDecoding.objectIdentifierKey:ModelCMSPage.registerName,
            "cms_page_id": cms_page_id! as Int,
            "uri": uri! as String,
            "template_path": template_path! as String,
            "title": title! as String,
            "description": description! as String,
            "variables": variables as [String:Any]
        ]
    }


}
