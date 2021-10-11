import Combine

extension Publisher {
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
    }
    
    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error).eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == Never {
    public func sink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void) -> AnyCancellable {
        sink(
            receiveCompletion: receiveCompletion,
            receiveValue: { _ in /* Don't handle value since it's of type Never and will "never" be received ;-) */ }
        )
    }
}
