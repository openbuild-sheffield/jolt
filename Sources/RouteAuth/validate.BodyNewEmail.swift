import OpenbuildExtensionPerfect

let ValidateBodyNewEmail = RequestValidationBody(
    name: "new_email",
    required: true,
    type: RequestValidationTypeString(
        email: true
    )
)