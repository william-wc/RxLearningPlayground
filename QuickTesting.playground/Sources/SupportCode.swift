import Foundation

public func delay(delay: TimeInterval, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

#if NOT_IN_PLAYGROUND
    public func playgroundTimeLimit(seconds: TimeInterval) {}
#else
    import PlaygroundSupport
    public func playgroundTimeLimit(seconds: TimeInterval = 0) {
        PlaygroundPage.current.needsIndefiniteExecution = true
        if seconds > 0 {
            delay(delay: seconds) {
                PlaygroundPage.current.finishExecution()
            }
        }
    }
#endif
