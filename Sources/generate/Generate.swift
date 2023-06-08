//
//  Generate.swift
//  

import Foundation
import ArgumentParser
import ApolloCodegenLib

@main
public struct Generate: ParsableCommand {
    
    @Option(name: [.short, .customLong("relative-path")], help: "A target path relative to the directory in which the build tool is located.")
    var relativePath: String?
    
    @Option(name: [.short, .customLong("absolute-path")], help: "An absolute path to the target directory.")
    var absolutePath: String?

    
    @Option(name: [.short, .customLong("schema-name")], help: "The name of the Apollo schema package that will be generated")
    var schemaName: String?
    
    public init() { }
    
    mutating public func run() throws {
        do {
            let configuration = try CodeGenerationConfiguration(
                schemaName: schemaName,
                relativePath: relativePath,
                absolutePath: absolutePath
            )
            print("🤖 Initiating Apollo Code Generation")
            try configuration.build()
        } catch {
            print("🛑 Error: (\(error)) \(error.localizedDescription)")
        }
    }
    
}
