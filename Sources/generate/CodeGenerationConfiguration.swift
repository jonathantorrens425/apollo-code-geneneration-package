//
//  File.swift
//  
//
//  Created by Jonathan Torrens on 1/14/23.
//

// Argument Parser Documentation:
// https://swiftpackageindex.com/apple/swift-argument-parser/1.2.1/documentation/argumentparser/gettingstarted
// Files Package:
// https://github.com/johnsundell/files

import Foundation
import ArgumentParser
import ApolloCodegenLib

enum CodeGenerationError: Swift.Error, LocalizedError {
    case invalidFilePath(attemptedTargetPath: String, relativePathProvided: String)
    
    var errorDescription: String? {
        switch self {
        case let .invalidFilePath(attemptedTargetPath, relativePathProvided):
            return "🛑 File Path Error: Attempted to access root package folder at \(attemptedTargetPath) with relative path: \(relativePathProvided)"
        }
    }
}

struct CodeGenerationConfiguration {
    let configuration: ApolloCodegenConfiguration
    
        
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
    
    
    init(packageName: String, relativePath: String) throws {
        let trimmedPath = relativePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let schemaPaths = ["\(trimmedPath)/**/*.graphqls", "\(trimmedPath)/*.graphqls"]
        let operationsPaths = ["\(trimmedPath)/**/*.graphql", "\(trimmedPath)/*.graphql"]
                      
        
        
        let currentPath = FileManager.default.currentDirectoryPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let destinationPath = "/\(currentPath)/\(trimmedPath)"
        print("Destination Path: \(destinationPath)")
        
        print("Searching for schemas (.graphqls) files at: \(schemaPaths)")
        print("Searching for operations (.graphql) files at: \(operationsPaths)")

        let schemaTypes = ApolloCodegenConfiguration
            .SchemaTypesFileOutput(
                path: "\(trimmedPath)/",
                moduleType: .swiftPackageManager)
        
        let outputConfiguration = ApolloCodegenConfiguration
            .FileOutput(
                schemaTypes: schemaTypes,
                operations: .inSchemaModule,
                testMocks: .swiftPackage())
        
        
        let inputConfiguration = ApolloCodegenConfiguration.FileInput(
            schemaSearchPaths: schemaPaths,
            operationSearchPaths: operationsPaths)
        
        configuration = ApolloCodegenConfiguration(
            schemaName: packageName,
            input: inputConfiguration,
            output: outputConfiguration,
            options: Self.outputOptions)
    }
    
    func build() throws {
        try ApolloCodegen.build(with: configuration)
    }
    
}
