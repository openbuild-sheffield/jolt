import Foundation
import PerfectLib

public struct ResponseDocumentation {

    private static var cacheRAML: [String: [String]] = [:]

    public static func getRAML(key: String) -> [String]? {

        if let lines = self.cacheRAML[key] {
            return lines
        } else {
            return nil
        }

    }

    public static func setRAML(key: String, lines: [String]) {
        self.cacheRAML[key] = lines
    }

    public static func deleteRAML(key: String) {
        self.cacheRAML.removeValue(forKey: key)
    }

    public static func genRAML(mirror: Mirror, descriptions: [String: String]) -> [String] {

        var lines = [String]()

        for c in mirror.children {

            if String(describing: type(of: c.value)).hasPrefix("Optional") {
                lines.append("\(c.label!)?:")
            } else {
                lines.append("\(c.label!):")
            }

            switch c.value {
                case is [String:Any]:
                    lines.append("  type: object")
                case is Bool:
                    lines.append("  type: bool")
                case is Int:
                    lines.append("  type: int")
                case is String:
                    lines.append("  type: string")
                case is JSONConvertibleObject:
                    lines.append("  type: object")
                default:
                    print("FIXME genRAML description")
                    print("NOT HANDLED")
                    print(mirror as Any)
                    print(c.value)
                    exit(0)

            }

            if let description = descriptions[c.label!] {
                lines.append("  description: \(description)")
            }

        }

        lines.append("example:")

        for c in mirror.children {

            if String(describing: type(of: c.value)).hasPrefix("Optional") {
                switch c.value {
                    case is Bool:
                        let value = c.value as! Bool
                        lines.append("  \(c.label!): \(value)")
                    case is Int:
                        let value = c.value as! Int
                        lines.append("  \(c.label!): \(value)")
                    case is String:
                        let value = c.value as! String
                        lines.append("  \(c.label!): \(value)")
                    default:
                        print("FIXME genRAML example")
                        print("NOT HANDLED")
                        print(mirror as Any)
                        print(c.value)
                        exit(0)
                }

            } else {

                switch c.value {
                    case is JSONConvertibleObject:
                        let value = c.value as! JSONConvertibleObject
                        do {
                            let encoded = try value.jsonEncodedString()
                            lines.append("  \(c.label!): \(encoded)")
                        } catch {
                            lines.append("  \(c.label!): \(c.value)")
                        }
                    case is [String:Any]:
                        let value = c.value as! [String:Any]
                        do {
                            let encoded = try value.jsonEncodedString()
                            lines.append("  \(c.label!): \(encoded)")
                        } catch {
                            lines.append("  \(c.label!): \(c.value)")
                        }
                    default:
                       lines.append("  \(c.label!): \(c.value)")
                }

            }

        }

        return lines

    }

}