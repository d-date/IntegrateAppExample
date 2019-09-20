import Foundation

extension NSObjectProtocol {
    func store(in bag: inout [NSObjectProtocol]? ) {
        bag?.append(self)
    }
}

extension Array where Element == NSObjectProtocol {
    func dispose() {
        self.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
