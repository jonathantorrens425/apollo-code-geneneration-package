//
//  File.swift
//  
//
//  Created by Jonathan Torrens on 1/14/23.
//

import Foundation
import ArgumentParser
import ApolloCodegenLib

@main
public struct Generate: ParsableCommand {
    
    @Option(name: [.short, .customLong("relative-path")], help: "A path relative to the same directory in which the build tool is located.")
    var relativePath: String
    
    @Option(name: [.short, .customLong("package-name")], help: "The name of the Apollo package that will be generated")
    var packageName: String
    
    public init() { }
    
    mutating public func run() throws {
        do {
            let configuration = try CodeGenerationConfiguration(packageName: packageName, relativePath: relativePath)
            print("🤖 Initiating Apollo Code Generation")
            try configuration.build()
        } catch {
            print("🛑 Error: (\(error)) \(error.localizedDescription)")
        }
    }
    
}
