import PerfectLib
import OpenbuildExtensionPerfect

public class ModelCMSWords: JSONConvertibleObject, DocumentationProtocol {

    static let registerName = "CMS.CMSWords"

    public var cms_words_id: Int?
    public var handle: String?
    public var words: String?
    public var errors: [String: String] = [:]

    public init(dictionary: [String : Any]) {
        self.cms_words_id = Int(dictionary["cms_words_id"]! as! UInt32)
        self.handle = dictionary["handle"] as? String
        self.words = dictionary["words"] as? String
    }

    public init(cms_words_id: Int, handle: String, words: String) {
        self.cms_words_id = cms_words_id
        self.handle = handle
        self.words = words
    }

    public init(cms_words_id: String, handle: String, words: String) {
        self.cms_words_id = Int(cms_words_id)
        self.handle = handle
        self.words = words
    }

    public init(handle: String, words: String) {
        self.handle = handle
        self.words = words
    }

    public override func getJSONValues() -> [String : Any] {
        return [
            JSONDecoding.objectIdentifierKey:ModelCMSWords.registerName,
            "cms_words_id": cms_words_id! as Int,
            "handle": handle! as String,
            "words": words! as String
        ]
    }

    public static func describeRAML() -> [String] {
        //TODO / FIXME
        return ["CMS: ModelCMSWords TODO / FIXME"]
    }

}