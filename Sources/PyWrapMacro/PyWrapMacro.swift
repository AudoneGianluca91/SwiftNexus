
import SwiftSyntax
import SwiftSyntaxMacros
import PythonKit

public struct PyWrapMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in ctx: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let args = attribute.arguments?.as(LabeledExprListSyntax.self),
              let modLit = args.first(where: { $0.label?.text == "module" })?
                .expression.as(StringLiteralExprSyntax.self)?
                .segments.first?.description.replacing(""", with: ""),
              let nameLit = args.first(where: { $0.label?.text == "name" })?
                .expression.as(StringLiteralExprSyntax.self)?
                .segments.first?.description.replacing(""", with: "")
        else { return [] }

        let code = """
        public let _py: PythonObject
        public init(_ obj: PythonObject) { self._py = obj }

        private static var _mod: PythonObject = Python.import(\"\(modLit)\")

        public static func new(_ args: PythonConvertible...) -> Self {
            let t = Python.tuple(args.map { PythonObject($0) })
            return Self(_mod.\"\(nameLit)\"(t))
        }

        public func mean() throws -> Double {
            try PyValue(_py.mean()).double()
        }
        """
        return [DeclSyntax(stringLiteral: code)]
    }
}
