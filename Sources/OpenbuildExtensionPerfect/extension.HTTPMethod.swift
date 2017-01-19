import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

public extension HTTPMethod {

    public static func exists(method: String) -> Bool {

        switch method.uppercased() {
            case "OPTIONS": return true
            case "GET":     return true
            case "HEAD":    return true
            case "POST":    return true
            case "PUT":     return true
            case "DELETE":  return true
            case "TRACE":   return true
            case "CONNECT": return true
            default: return false
        }

    }

    public static func fromString(method: String) -> HTTPMethod {
        return self.from(string: method.uppercased())
    }

}