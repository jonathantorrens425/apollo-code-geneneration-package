//
//  File.swift
//  
//
//  Created by Jonathan Torrens on 1/14/23.
//

import Foundation
import ArgumentParser
import ApolloCodegenLib

// Argument Parser Documentation:
// https://swiftpackageindex.com/apple/swift-argument-parser/1.2.1/documentation/argumentparser/gettingstarted

struct Build: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Builds the Apollo GraphQL code")
    
    func run() throws {
        print("Building Apollo GraphQL Code")
        do {
            try CodeGenerationConfiguration.build()
        } catch {
            print("🛑 Error: \(error)")
        }
        
    }
}

enum CodeGenerationConfiguration {
    static let inputConfiguration = ApolloCodegenConfiguration
        .FileInput(
            schemaSearchPaths: ["../*.graphqls"],
            operationSearchPaths: ["../*.graphql"])
    
    static let schemaTypes = ApolloCodegenConfiguration
        .SchemaTypesFileOutput(
            path: "./generated/schema",
            moduleType: .swiftPackageManager)
    
    static let outputConfiguration = ApolloCodegenConfiguration
        .FileOutput(
            schemaTypes: schemaTypes,
            operations: .inSchemaModule,
            testMocks: .swiftPackage())
    
    static let conversionStategies = ApolloCodegenConfiguration
        .ConversionStrategies(enumCases: .camelCase)
    
    static let outputOptions = ApolloCodegenConfiguration
        .OutputOptions(
            additionalInflectionRules: [],
            queryStringLiteralFormat: .multiline,
            deprecatedEnumCases: .include,
            schemaDocumentation: .include,
            apqs: .disabled,
            cocoapodsCompatibleImportStatements: false,
            warningsOnDeprecatedUsage: .include,
            conversionStrategies: conversionStategies,
            pruneGeneratedFiles: true)
    
    static let yelpConfiguration = ApolloCodegenConfiguration(
        schemaName: "YelpSchema",
        input: inputConfiguration,
        output: outputConfiguration,
        options: outputOptions)
    
    static func build() throws {
        try ApolloCodegen.build(with: yelpConfiguration)
    }
    
}
