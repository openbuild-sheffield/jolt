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

            let repositoryCMSMarkdown = try RepositoryCMSMarkdown()
            let repositoryCMSMardownInstall = try repositoryCMSMarkdown.install()
            print("repositoryCMSMardownInstall: \(repositoryCMSMardownInstall)")

            let repositoryCMSWords = try RepositoryCMSWords()
            let repositoryCMSWordsInstall = try repositoryCMSWords.install()
            print("repositoryCMSWordsInstall: \(repositoryCMSWordsInstall)")


        } catch {

            print("ERROR: \(error)")
            exit(0)

        }

        return true

    }

}