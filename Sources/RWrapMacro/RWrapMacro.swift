
import SwiftSyntax
import SwiftSyntaxMacros

public struct RWrapMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in ctx: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let args = attribute.arguments?.as(LabeledExprListSyntax.self),
              let pkgLit = args.first(where: { $0.label?.text == "package" })?
                .expression.as(StringLiteralExprSyntax.self)?
                .segments.first?.description.replacing(""", with: ""),
              let nameLit = args.first(where: { $0.label?.text == "name" })?
                .expression.as(StringLiteralExprSyntax.self)?
                .segments.first?.description.replacing(""", with: "")
        else { return [] }

        let code = """
        public let _r: RValue
        public init(_ rv: RValue) { self._r = rv }

        public static func new(_ args: RConvertible...) -> Self {
            let joined = args.map { $0.rLiteral }.joined(separator: ",")
            let code = \"\(pkgLit)::\(nameLit)(\(joined))\"
            return Self(RValue(rwrap_eval(code)))
        }
        """
        return [DeclSyntax(stringLiteral: code)]
    }
}
