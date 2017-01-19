import OpenbuildExtensionPerfect

let ValidateBodyMarkdown = RequestValidationBody(
    name: "markdown",
    required: true,
    type: RequestValidationTypeString()
)