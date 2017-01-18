import Foundation

public enum RepoError: Error {
    case connection(messagePublic: String, messageDev: String)
    case connect(message: String)
    case queryFailed(message: String)
    case statementPrepareFailed(message: String)
    case statementExecuteFailed(message: String)
}