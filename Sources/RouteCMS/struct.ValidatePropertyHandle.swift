import OpenbuildExtensionPerfect

public struct validatePropertyHandle {
    public var name = "handle"
    public var required = true
    public var type = RequestValidationTypeString(
        min: 3,
        max: 255,
        regex: "^[A-Za-z0-9]{3,255}$"
    )
}

let ValidatePropertyHandle = validatePropertyHandle()