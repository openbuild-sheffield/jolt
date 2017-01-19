import Foundation

open class FactoryRoute
{
    open class func create(name : String) -> FactoryRoute? {

        guard let any : AnyObject.Type = NSClassFromString(name) else {
            return nil
        }

        guard let ns = any as? FactoryRoute.Type else {
            return nil;
        }

        return ns.init()
    }

    public required init(){}

    open func route() -> NamedRoute? {
        return nil
    }

}
