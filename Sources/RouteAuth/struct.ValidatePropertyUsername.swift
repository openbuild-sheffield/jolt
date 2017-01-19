import OpenbuildExtensionPerfect

public struct validatePropertyUsername {
    public var name = "username"
    public var required = true
    public var type = RequestValidationTypeString(
        min: 3,
        max: 255,
        regex: "^[A-Za-z0-9]{3,255}$"
    )
}

let ValidatePropertyUsername = validatePropertyUsername()