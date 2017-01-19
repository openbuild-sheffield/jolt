import OpenbuildExtensionPerfect

let ValidateBodyPageURI = RequestValidationBody(
    name: "uri",
    required: true,
    type: RequestValidationTypeString(
        regex: "^/(.*){1,255}$"
    )
)