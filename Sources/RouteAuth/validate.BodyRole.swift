import OpenbuildExtensionPerfect

let ValidateBodyRole = RequestValidationBody(
    name: "role",
    required: true,
    type: RequestValidationTypeString(
        min: 3,
        max: 255,
        regex: "^[A-Za-z ]{3,255}$"
    )
)