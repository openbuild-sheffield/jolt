import OpenbuildExtensionPerfect

let ValidateBodyPageTitle = RequestValidationBody(
    name: "title",
    required: true,
    type: RequestValidationTypeString(
        regex: "^(.*){1,255}$"
    )
)