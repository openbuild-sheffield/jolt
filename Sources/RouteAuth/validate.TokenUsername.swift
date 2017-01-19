import OpenbuildExtensionPerfect

let ValidateTokenUsername = RequestValidationToken(
    key: "user",
    name: "username",
    required: true,
    type: RequestValidationTypeString(
        isString: "admin2"
    )
)