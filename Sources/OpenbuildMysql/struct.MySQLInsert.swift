public struct MySQLInsert {

    public var error: Bool = false
    public var errorMessage: String?
    public var affectedRows: UInt?
    public var insertId: UInt?

    public mutating func setErrorMessage(message: String){
        error = true
        errorMessage = message
    }

}