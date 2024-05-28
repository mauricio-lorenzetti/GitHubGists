//
//  GitHubGistsTests.swift
//  GitHubGistsTests
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import XCTest
import Combine
@testable import GitHubGists

final class GitHubGistsTests: XCTestCase {
        
    var sut: GistViewModel!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = GistViewModel(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkClient = nil
        super.tearDown()
    }
    
    func testFetchGists() {
        // Prepare mock data and expectations
        let mockGistList = [GistModel(filesCount: "2", login: "TestUser", avatarURL: URL(string: "https://example.com/avatar.png")!, htmlURL: URL(string: "https://example.com/gist")!)]
        
        mockNetworkClient.mockResponse = mockGistList
        
        // Call the method under test
        sut.fetchGists()
        
        // Assert the state and gistList after completion
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.gistList, mockGistList)
    }
}

// Mock NetworkClient for testing
class MockNetworkClient: ClientProtocol {
    var mockResponse: [GistModel]?
    
    func getClientData(page: Int) -> Future<[GistModel], DataError> {
        if let mockResponse = mockResponse {
            return Future { promise in
                promise(.success(mockResponse))
            }
        } else {
            return Future { promise in
                promise(.failure(.networkError(description: "Mock Network Error")))
            }
        }
    }
}
