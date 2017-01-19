import Foundation

open class FactoryInstaller
{
    open class func create(name : String) -> FactoryInstaller? {

        guard let any : AnyObject.Type = NSClassFromString(name) else {
            return nil
        }

        guard let ns = any as? FactoryInstaller.Type else {
            return nil;
        }

        return ns.init()

    }

    public required init(){}

    open func install() -> Bool? {
        return nil
    }

}
