import OpenbuildExtensionPerfect

let ValidateBodyPageDescription = RequestValidationBody(
    name: "description",
    required: true,
    type: RequestValidationTypeString(
        regex: "^(.*){1,255}$"
    )
)