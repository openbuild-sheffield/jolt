import OpenbuildExtensionPerfect

//TODO / FIXME - change this to a closure and check if the template exists
let ValidateBodyTemplatePath = RequestValidationBody(
    name: "template_path",
    required: true,
    type: RequestValidationTypeString(
        regex: "^(.*){1,255}$"
    )
)