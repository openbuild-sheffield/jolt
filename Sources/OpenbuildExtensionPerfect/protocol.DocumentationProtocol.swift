import PerfectLib

public protocol DocumentationProtocol {

    static func describeRAML() -> [String]

}

extension DocumentationProtocol {
    func getRegisteredName() -> String {
        return "??????"
    }
}