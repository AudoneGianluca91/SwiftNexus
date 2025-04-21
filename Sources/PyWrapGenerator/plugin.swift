
import PackagePlugin
import Foundation

@main struct PyWrapGenerator: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let config = context.package.directory.appending("Modules.wrap")
        let defaultLines = ["numpy,array", "pandas,DataFrame"]
        let lines: [String] = (try? String(contentsOfFile: config.string))?
            .split(separator: "\n").map(String.init) ?? defaultLines

        var content = "import PyWrapRuntime\nimport PyWrapMacro\n\n"
        for l in lines {
            let parts = l.split(separator: ",")
            if parts.count == 2 {
                content += "@pywrap(module: \"\(parts[0])\", name: \"\(parts[1])\")\nstruct \(parts[1]) {}\n\n"
            }
        }

        let outDir = context.pluginWorkDirectory
        let outFile = outDir.appending("GeneratedWrappers.swift")
        try FileManager.default.createDirectory(atPath: outDir.string, withIntermediateDirectories: true)
        try content.write(toFile: outFile.string, atomically: true, encoding: .utf8)

        return [.prebuildCommand(displayName: "Generate Python wrappers",
                                 executable: Path("/bin/echo"),
                                 arguments: [],
                                 environment: [:],
                                 outputFilesDirectory: outDir)]
    }
}

// TODO: integrate stubgen parsing for fuller signatures
