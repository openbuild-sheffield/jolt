import Foundation

public extension Collection where Iterator.Element: Equatable {
    public func split<S: Sequence>(separators: S) -> [SubSequence]
        where Iterator.Element == S.Iterator.Element
    {
        return split { separators.contains($0) }
    }
}