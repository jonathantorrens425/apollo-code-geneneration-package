//
//  CodeGeneration.swift
//  

// Argument Parser Documentation:
// https://swiftpackageindex.com/apple/swift-argument-parser/1.2.1/documentation/argumentparser/gettingstarted
// Files Package:
// https://github.com/johnsundell/files

import Foundation
import ArgumentParser
import ApolloCodegenLib

enum CodeGenerationError: Swift.Error, LocalizedError {
    case relativeAndAbsolutePathsProvided
    
    var errorDescription: String? {
        switch self {
        case .relativeAndAbsolutePathsProvided:
            return "🛑 You cannot specify both a relative and absolute path."
        }
    }
}


enum PathArgumentParser {
    static func resolveSearchPaths(relativePath: String?, absolutePath: String?) throws -> SearchPaths{
        if relativePath != nil && absolutePath != nil { throw CodeGenerationError.relativeAndAbsolutePathsProvided }
        var trimmedPath = ""
        if let relativePath = relativePath {
            trimmedPath = relativePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            
            return SearchPaths(
                operationsPath: ["\(trimmedPath)/**/*.graphqls", "\(trimmedPath)/*.graphqls"],
                schemaPaths: ["\(trimmedPath)/**/*.graphql", "\(trimmedPath)/*.graphql"],
                rootDirectory: "\(trimmedPath)/"
            )
            
        } else if let  absolutePath = absolutePath {
            trimmedPath = absolutePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

            return SearchPaths(
                operationsPath: ["/\(trimmedPath)/**/*.graphqls", "/\(trimmedPath)/*.graphqls"],
                schemaPaths: ["/\(trimmedPath)/**/*.graphql", "/\(trimmedPath)/*.graphql"],
                rootDirectory: "/\(trimmedPath)/"
            )
        } else {
            return SearchPaths(
                operationsPath: ["./**/*.graphqls", "./*.graphqls"],
                schemaPaths: ["./**/*.graphql", "./*.graphql"],
                rootDirectory: "./"
            )
        }
    }
}

struct SearchPaths {
    let operationsPath: [String]
    let schemaPaths: [String]
    let rootDirectory: String
}

struct CodeGenerationConfiguration {
    let apolloConfiguration: ApolloCodegenConfiguration
            
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
    

    
    init(schemaName: String?, relativePath: String?, absolutePath: String?) throws {
        let schemaName = schemaName ?? "ApolloSchemaPackage"
        let searchPaths = try PathArgumentParser.resolveSearchPaths(relativePath: relativePath, absolutePath: absolutePath)
        
        let schemaTypes = ApolloCodegenConfiguration
            .SchemaTypesFileOutput(
                path: searchPaths.rootDirectory,
                moduleType: .swiftPackageManager)
        
        let outputConfiguration = ApolloCodegenConfiguration
            .FileOutput(
                schemaTypes: schemaTypes,
                operations: .inSchemaModule,
                testMocks: .swiftPackage())
        
        let inputConfiguration = ApolloCodegenConfiguration.FileInput(
            schemaSearchPaths: searchPaths.schemaPaths,
            operationSearchPaths: searchPaths.operationsPath)
        
        apolloConfiguration = ApolloCodegenConfiguration(
            schemaName: schemaName,
            input: inputConfiguration,
            output: outputConfiguration,
            options: Self.outputOptions)
    }
    
    func build() throws {
        try ApolloCodegen.build(with: apolloConfiguration)
    }
    
}
