
import PackagePlugin
import Foundation

@main struct RWrapGenerator: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {
        let config = context.package.directory.appending("RModules.wrap")
        let defaultLines = ["stats,lm"]
        let lines: [String] = (try? String(contentsOfFile: config.string))?
            .split(separator: "\n").map(String.init) ?? defaultLines

        var content = "import RWrapRuntime\nimport RWrapMacro\n\n"
        for l in lines {
            let parts = l.split(separator: ",")
            if parts.count == 2 {
                content += "@rwrap(package: \"\(parts[0])\", name: \"\(parts[1])\")\nstruct \(parts[1]) {}\n\n"
            }
        }

        let outDir = context.pluginWorkDirectory
        let outFile = outDir.appending("GeneratedRWrappers.swift")
        try FileManager.default.createDirectory(atPath: outDir.string, withIntermediateDirectories: true)
        try content.write(toFile: outFile.string, atomically: true, encoding: .utf8)

        return [.prebuildCommand(displayName: "Generate R wrappers",
                                 executable: Path("/bin/echo"),
                                 arguments: [],
                                 environment: [:],
                                 outputFilesDirectory: outDir)]
    }
}
