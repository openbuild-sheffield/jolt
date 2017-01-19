import OpenbuildExtensionPerfect

let ValidateTokenRoles = RequestValidationToken(
    key: "user",
    name: "roles",
    required: true,
    type: RequestValidationTypeArray(
        anyOnePartial: [
            ["role": "Admin"],
            ["role": "Editor"]
        ]
    )
)