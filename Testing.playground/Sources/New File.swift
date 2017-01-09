import Foundation

public func with(_ closure: () -> ()) {
    closure()
    
    print("\n\n")
}
