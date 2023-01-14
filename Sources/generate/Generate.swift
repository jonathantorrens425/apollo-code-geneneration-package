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
    
    public init() {
        
    }
    
    mutating public func run() throws {
        do {
            try CodeGenerationConfiguration.build()
        } catch {
            print("🛑 Error: (\(error)) \(error.localizedDescription)")
        }
    }
    
}
