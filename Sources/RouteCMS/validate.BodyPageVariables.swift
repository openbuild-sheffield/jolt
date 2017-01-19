import OpenbuildExtensionPerfect
import OpenbuildExtensionCore

let ValidateBodyPageVariables = RequestValidationBody(
    name: "variables",
    required: true,
    type: RequestValidationTypeArray(
        closure: { (data: Any) -> RequestValidation in

            var results = RequestValidation()

            if let dataDictionary = data as? [String: Any] {

                if dataDictionary["variable"] == nil {

                    results.addError(key: "variable", value: "Should be set")

                }else{

                    if dataDictionary["variable"] as! String !=~ "^[A-Za-z0-9]{3,255}$" {
                        results.addError(
                            key:"variable",
                            value: "Should match ^[A-Za-z0-9]{3,255}$."
                        )
                    }

                }

                if dataDictionary["content"] == nil {

                    results.addError(key: "content", value: "Should be set")

                } else {

                    if let contentArray = dataDictionary["content"]! as? [[String: String]] {

                        for (index, v) in contentArray.enumerated(){

                            var errors: [String:String] = [:]

                            if v["type"] == nil {
                                errors["type"] = "Should be set"
                            } else if v["type"]! != "markdown" && v["type"]! != "words" {
                                errors["type"] = "Should be 'markdown' or 'words'"
                            }

                            if v["handle"] == nil {
                                errors["handle"] = "Should be set"
                            } else if v["handle"]! !=~ "^[A-Za-z0-9_]{3,255}$"  {
                                errors["handle"] = "Should match ^[A-Za-z0-9_]{3,255}$"
                            }

                            if errors.isEmpty == false {
                                results.addError(key: "content_\(index)", value: errors)
                            } else {

                                //Looks valid so check if it's in the DB
                                if v["type"] == "markdown" {

                                    do {

                                        var repositoryMarkdown = try RepositoryCMSMarkdown()

                                        let entityMarkdown = try repositoryMarkdown.getByHandle(
                                            handle: v["handle"]!
                                        )

                                        if entityMarkdown == nil {
                                            errors["handle"] = "Not found"
                                        }

                                    } catch {

                                        errors["handle"] = "Not found"

                                    }
                                }

                                if v["type"] == "words" {

                                    do {

                                        var repositoryWords = try RepositoryCMSWords()

                                        let entityWords = try repositoryWords.getByHandle(
                                            handle: v["handle"]!
                                        )

                                        if entityWords == nil {
                                            errors["handle"] = "Not found"
                                        }

                                    } catch {

                                        errors["handle"] = "Not found"

                                    }

                                }

                                if errors.isEmpty == false {
                                    results.addError(key: "content_\(index)", value: errors)
                                }

                            }

                        }

                    }else{

                        results.addError(key: "format", value: "Content doesn't appear to be a valid array.")

                    }

                }

            } else {

                results.addError(key: "format", value: "Item doesn't appear to be a valid object.")

            }

            return results

        },
        raml: { () -> [String] in

            var raml = ["type: array"]
            raml.append("minItems: 1")
            raml.append("items:")
            raml.append("  type: object")
            raml.append("  description: Object describing the variable and it's content.")
            raml.append("  properties:")
            raml.append("    variable:")
            raml.append("      type: string")
            raml.append("      description: the variable used in the template")
            raml.append("    content:")
            raml.append("      type: array")
            raml.append("      description: array of content type objects")
            raml.append("      items:")
            raml.append("        type: object")
            raml.append("        properties:")
            raml.append("          content_type:")
            raml.append("            type: string")
            raml.append("            description: the type of content, currently words or markdown")
            raml.append("            pattern: ^(markdown|words)$")
            raml.append("          handle:")
            raml.append("            type: string")
            raml.append("            description: the handle used to lookup the content")
            raml.append("            pattern: ^[A-Za-z0-9_]{3,255}$")
            raml.append("example:")
            raml.append("  -")

            return raml

        }
    )
)