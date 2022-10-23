struct MethodStub {

    static func failable<E>(with error: E) throws where E: Error {
        throw error
    }

    static func nonFailable() throws { }
}
