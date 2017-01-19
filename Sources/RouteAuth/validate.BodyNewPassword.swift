import OpenbuildExtensionPerfect

let ValidateBodyNewPassword = RequestValidationBody(
    name: "new_password",
    required: true,
    type: RequestValidationTypeString(
        min: 7,
        max: 255,
        regex: "^.{7,255}$"
    )
)