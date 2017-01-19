import OpenbuildExtensionPerfect

let ValidateBodyPassword = RequestValidationBody(
    name: "password",
    required: true,
    type: RequestValidationTypeString(
        min: 7,
        max: 255,
        regex: "^.{7,255}$"
    )
)