import XCTest
import ApolloCodegenLib

@testable import ApolloCodeGenerationPackage

final class ApolloCodeGenerationPackageTests: XCTestCase {

    func testPathParsing() throws {
        let relativePathEndingSlash = "./../test/"
        let currentDirectory = FileManager.default.currentDirectoryPath.split(separator: "/")
        
        let configuration = try CodeGenerationConfiguration(
            schemaName: nil, relativePath: relativePathEndingSlash, absolutePath: nil)
        
        XCTAssertTrue(configuration.apolloConfiguration.schemaName == "ApolloSchemaPackage")
        
        
        
    }
    
}
