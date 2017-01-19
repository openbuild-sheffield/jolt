import OpenbuildExtensionPerfect

let ValidateUriRoleId = RequestValidationUri(
    name: "role_id",
    required: true,
    type: RequestValidationTypeInt(
        min: 1,
        max: 4294967295
    )
)