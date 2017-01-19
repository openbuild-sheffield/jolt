import Foundation

open class FactoryRamlDoc {

    open class func getDocumentation(name : String) -> [String]? {

        guard let any : AnyObject.Type = NSClassFromString(name) else {
            return nil
        }

        guard let ns = any as? DocumentationProtocol.Type else {
            return nil;
        }

        return ns.describeRAML()

    }

    public required init(){}

}