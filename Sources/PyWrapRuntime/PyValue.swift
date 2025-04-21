
import PythonKit

@dynamicMemberLookup
public struct PyValue {
    public let raw: PythonObject
    public init(_ raw: PythonObject) { self.raw = raw }

    public subscript(dynamicMember member: String) -> PyValue {
        PyValue(raw[dynamicMember: member])
    }

    public func call(_ args: PythonConvertible...) -> PyValue {
        let tuple = Python.tuple(args.map { PythonObject($0) })
        return PyValue(raw.call(with: tuple))
    }

    public func double() throws -> Double {
        guard let d = Double(raw) else { throw PyError.castFailure("Double") }
        return d
    }
}

public protocol PythonConvertible {}
extension PythonConvertible { public var py: PythonObject { PythonObject(self) } }
extension Int: PythonConvertible {}
extension Double: PythonConvertible {}
extension String: PythonConvertible {}
extension Array: PythonConvertible where Element: PythonConvertible {}

public enum PyError: Error { case castFailure(String) }

public func `import`(_ name: String) -> PyValue { PyValue(Python.import(name)) }

// MARK: – Zero‑copy buffer helper (NumPy ndarray → Swift buffer)

import NIOCore

extension PyValue {
    /// Call `body` with an `UnsafeBufferPointer<Double>` backed by the
    /// **original NumPy data** (no copies). Works only for C‑contiguous
    /// double arrays.
    public func withUnsafeBufferPointer<R>(_ body: (UnsafeBufferPointer<Double>) throws -> R) rethrows -> R {
        // 1. Ask NumPy for the raw pointer via the `__array_interface__`
        let ai = raw.__array_interface__
        guard let ptrInt = Int(ai["data"][0]) else {
            fatalError("Not a C‑contiguous ndarray")
        }
        let count = Int(ai["shape"][0]) * (ai["shape"].count > 1 ? Int(ai["shape"][1]) : 1)
        let ptr = UnsafePointer<Double>(bitPattern: ptrInt)!
        return try body(UnsafeBufferPointer(start: ptr, count: count))
    }
}
