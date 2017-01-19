import OpenbuildExtensionPerfect

let ValidateBodyEmail = RequestValidationBody(
    name: "email",
    required: true,
    type: RequestValidationTypeString(
        email: true
    )
)