
import Foundation

@dynamicMemberLookup
public struct RValue {
    private let sexp: OpaquePointer
    public init(_ sexp: OpaquePointer) { self.sexp = sexp }

    public subscript(dynamicMember name: String) -> RValue {
        let expr = "get(\"\(name)\")"
        return RValue(rwrap_eval(expr))
    }

    public func call(_ args: RConvertible...) -> RValue {
        let joined = args.map { $0.rLiteral }.joined(separator: ",")
        let code = "(\(asString()))(\(joined))"
        return RValue(rwrap_eval(code))
    }

    public func asString() -> String {
        return "RValue" // simplistic
    }
}

public protocol RConvertible { var rLiteral: String { get } }
extension Double: RConvertible { public var rLiteral: String { description } }
extension Int: RConvertible { public var rLiteral: String { description } }
extension String: RConvertible { public var rLiteral: String { "\"\(self)\"" } }

private let _boot: Void = {
    var argv: [UnsafeMutablePointer<Int8>?] = []
    rwrap_init(0, &argv)
}()

// MARK: – Zero‑copy numeric buffer helper
public func withUnsafeBufferPointer<RType>(_ body: (UnsafeBufferPointer<Double>) throws -> RType) rethrows -> RType {
    let len = Rf_length(sexp)
    let ptr = Rf_realPtr(sexp)
    let buf = UnsafeBufferPointer(start: ptr, count: len)
    return try body(buf)
}
