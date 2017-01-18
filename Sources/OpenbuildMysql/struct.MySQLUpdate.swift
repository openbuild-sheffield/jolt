public struct MySQLUpdate {

    public var error: Bool = false
    public var errorMessage: String?
    public var affectedRows: UInt?

    public mutating func setErrorMessage(message: String){
        error = true
        errorMessage = message
    }

}