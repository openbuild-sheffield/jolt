import Foundation

public extension String {

    public init?(current: String, path: String) {

        if let index = current.range(of: "/", options: NSString.CompareOptions.backwards)?.lowerBound {

            let fullPath = current.substring(to: index) + "/" + path

            do {
                let data = try String(contentsOfFile: fullPath)
                self.init(data)
            } catch {
                self.init()
            }

        } else {
            self.init()
        }

    }

    public init?(utf8Bytes: [UInt8]) {

        let text = String(bytes: utf8Bytes, encoding: String.Encoding.utf8)
        self.init(text!)

    }

    public var isEmail: Bool {

        var isEmail = false

        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .link]
        let detector = try? NSDataDetector(types: types.rawValue)

        detector?.enumerateMatches(
            in: self,
            options: [],
            range: NSMakeRange(0, (self as NSString).length))
        {
            (result, flags, _) in

            if result!.resultType == .link  && result?.url?.absoluteString.lowercased().range(of: "mailto:") != nil{

                let checkEmail = result!.url!.absoluteString
                let start = checkEmail.index(checkEmail.startIndex, offsetBy: 7)
                let end = checkEmail.index(checkEmail.endIndex, offsetBy: 0)
                let range = start..<end

                if checkEmail.substring(with: range) == self.lowercased() {
                    isEmail = true
                }

            }

        }

        return isEmail

    }

    public var isInt: Bool {
        return Int(self) != nil
    }

    public var toInt: Int {
        return Int(self)!
    }

    public var contains: Bool {
        if self.range(of: self) != nil {
            return true
        } else {
            return false
        }
    }

}

infix operator =~

public func =~ (input: String, pattern: String) -> Bool {

    if let _ = input.range(of: pattern, options: .regularExpression) {
        return true
    } else {
        return false
    }

}

infix operator !=~

public func !=~ (input: String, pattern: String) -> Bool {

    if let _ = input.range(of: pattern, options: .regularExpression) {
        return false
    } else {
        return true
    }

}
