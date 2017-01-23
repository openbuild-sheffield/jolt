import Foundation
import PerfectHTTP
import PerfectHTTPServer
import PerfectLib
import OpenbuildRouteRegistry
import OpenbuildSingleton

let server = PerfectHTTPServer.HTTPServer()
var routes = PerfectHTTP.Routes()

do {

    let configURL = URL(fileURLWithPath: "./config.plist")
    let configData = try Data(contentsOf:configURL)
    let configDictionary = try PropertyListSerialization.propertyList(from: configData, options: [], format: nil) as! [String:Any]

    OpenbuildSingleton.Manager.setThemePath(path: configDictionary["theme"]! as! String)

    let serverConfig = ServerConfig(configDictionary["server"] as! [String: Any])

    if serverConfig == nil {

        print("Load config.plist error - Invalid server details")
        print(configDictionary["server"] as Any)
        exit(0)

    } else {

        server.documentRoot = serverConfig!.documentRoot
        server.serverPort = serverConfig!.port
        server.serverAddress = serverConfig!.address
        server.runAsUser = serverConfig!.runAsUser
        server.serverName = serverConfig!.name
        //TODO SSL

    }

    //Setup security singleton
    //_ = OpenbuildSingleton.Manager.getSecurity()
    let security = OpenbuildSingleton.Manager.getSecurity()
    print("")
    print("Random Strings (For passwords if you wish): ")
    print(security.randomString())
    print(security.randomString())
    print(security.randomString())
    print(security.randomString())
    print(security.randomString())
    print(security.randomString())
    print(security.randomString())
    print("")

    //TODO - Do a generic setup...
    //Setup mysql connections singleton
    _ = OpenbuildSingleton.Manager.getMySQLConnections()
    _ = OpenbuildSingleton.Manager.getModuleConnectionDetails()

    if configDictionary["routeModules"] == nil {
        print("Load config.plist error - No routeModules")
        exit(0)
    }

    var moduleConfigs: [[String: Any]] = Array()

    for moduleConfigPath in configDictionary["routeModules"] as! [String] {

        do {

            let configModuleURL = URL(fileURLWithPath: moduleConfigPath)
            let configModuleData = try Data(contentsOf:configModuleURL)
            let configModuleDictionary = try PropertyListSerialization.propertyList(from: configModuleData, options: [], format: nil) as! [String:Any]

            guard let moduleName = configModuleDictionary["Name"] else {
                print("Module requires a Name \(moduleConfigPath) \(configModuleDictionary)")
                exit(0)
            }

            if let dataConnection = configModuleDictionary["DataConnection"] {

                let dataConnectionDictionary = dataConnection as! [String:String]

                guard let dataConnectionConnection = dataConnectionDictionary["Connection"] else {
                    print("DataConnection requires Connection \(configModuleDictionary)")
                    exit(0)
                }

                guard let dataConnectionType = dataConnectionDictionary["Type"] else {
                    print("DataConnection requires Type \(configModuleDictionary)")
                    exit(0)
                }

                OpenbuildSingleton.Manager.addDataConnectionMap(
                    module: moduleName as! String,
                    connection: dataConnectionConnection,
                    type: dataConnectionType
                )

            }

            moduleConfigs.append(configModuleDictionary)

        } catch {

            print("Load \(moduleConfigPath) error")
            print("FAILED \(error)")
            exit(0)

        }

        //Setup routes
        print("")
        print("Adding routes from \(moduleConfigPath): ")
        for moduleConfig in moduleConfigs {

            if moduleConfig["Routes"] == nil {
                print("No Routes found in: \(moduleConfig)")
                exit(0)
            }

            for routeString in moduleConfig["Routes"] as! [String] {

                guard let factory = OpenbuildRouteRegistry.FactoryRoute.create(name: routeString) else {
                    print("Failed to load route factory \(routeString)")
                    exit(0)
                }

                guard let route = factory.route() else {
                    print("Failed to get route from factory \(routeString)")
                    exit(0)
                }

                routes.add(
                    method: HTTPMethod.fromString(method: route.method),
                    uri: route.uri,
                    handler: route.handlerRoute
                )

                RouteRegistry.addRouteMap(
                    key: routeString,
                    method: route.method,
                    uri: route.uri
                )

                print("ADDED ROUTE: \(route.method) \(route.uri)")

            }

        }

    }

    //All routes and DB connections are now set
    //Now check install - TODO dependencies
    for moduleConfig in moduleConfigs {

        if let installString = moduleConfig["Install"]{

            print("")
            print("Attempting to install \(moduleConfig["Name"]!)")

            guard let factoryInstaller = OpenbuildRouteRegistry.FactoryInstaller.create(name: installString as! String) else {
                print("Failed to load install factory \(installString)")
                exit(0)
            }

            guard let installed = factoryInstaller.install() else {
                print("Failed to install from factory \(installString)")
                exit(0)
            }

            if installed {
                print("Installed or upgraded: \(moduleConfig["Name"]!)")
            } else {
                print("No install or upgrade requires: \(moduleConfig["Name"]!)")
            }

        } else {

            print("")
            print("No install for \(moduleConfig["Name"]!)")

        }

    }

} catch {

    print("Load config.plist error")
    print("FAILED \(error)")
    exit(0)

}

//Challenge for http://letsencrypt.org certs
routes.add(method: .get, uri: ".well-known/acme-challenge", handler: { request, response in
    response.setBody(string: "well-known/acme-challenge was called")
    response.completed()
})

print("")

//Configure server with CLI options
configureServer(server)

//Set filters for status codes
server.setResponseFilters([(FilterHTTPStatusCode404(), .high)])

let requestFilters: [(HTTPRequestFilter, HTTPFilterPriority)] = [
    (FilterHTTPRequestParams(), HTTPFilterPriority.high)
]
server.setRequestFilters(requestFilters)

// Add the routes to the server.
server.addRoutes(routes)

//print("")
//print(Documentation.getRAML())
//print("")

print("")
print("If this is a first run you will want to send put requests to:")
print("/api/auth/update/password")
print("/api/auth/update/email")
print("for user with details: email: admin@test.com password: letmein")
print("")

do {

    // Launch the HTTP server.
    try server.start()

} catch PerfectError.networkError(let err, let msg) {

    print("Network error thrown: \(err) \(msg)")

}

