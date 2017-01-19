import OpenbuildExtensionPerfect

let ValidateBodyWords = RequestValidationBody(
    name: "words",
    required: true,
    type: RequestValidationTypeString()
)