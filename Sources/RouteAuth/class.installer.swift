import Foundation
import OpenbuildExtensionCore
import OpenbuildExtensionPerfect
import OpenbuildMysql
import OpenbuildRepository
import OpenbuildRouteRegistry
import OpenbuildSingleton

public class Installer: OpenbuildRouteRegistry.FactoryInstaller {

    override public func install() -> Bool? {

        print("Has Installer")

        do{

            let repositoryAuth = try RepositoryAuth()
            let repositoryAuthInstall = try repositoryAuth.install()
            print("repositoryAuthInstall: \(repositoryAuthInstall)")

            let repositoryRole = try RepositoryRole()
            let repositoryRoleInstall = try repositoryRole.install()
            print("repositoryRoleInstall: \(repositoryRoleInstall)")

            let repositoryUserLinkRole = try RepositoryUserLinkRole()
            let repositoryUserLinkRoleInstall = try repositoryUserLinkRole.install()
            print("repositoryUserLinkRoleInstall: \(repositoryUserLinkRoleInstall)")


        } catch {

            print("ERROR: \(error)")
            //exit(0)

        }

        return true

    }

}