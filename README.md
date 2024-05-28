# GitHubGists

GitHubGists is an iOS application that displays the latest gists from GitHub. The app is built using Swift, UIKit, Combine, and Kingfisher. It supports features such as infinite scrolling, pull-to-refresh, and detailed gist views with WKWebView.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Architecture](#architecture)
- [Testing](#testing)
- [License](#license)

## Requirements

- Xcode 12.0 or later
- iOS 14.0 or later
- Swift 5.0 or later

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/GitHubGists.git
   cd GitHubGists
   ```

2. Open the project in Xcode:
   ```sh
   open GitHubGists.xcodeproj
   ```

3. Install dependencies using CocoaPods:
   ```sh
   pod install
   ```

4. Build and run the project in Xcode.

## Usage

1. Launch the app on your iOS device or simulator.
2. The main screen displays a list of the latest gists.
3. Scroll down to load more gists (infinite scroll).
4. Pull down to refresh the list of gists.
5. Tap on a gist to view its details.

## Features

- **Infinite Scroll:** Automatically loads more gists as you scroll down.
- **Pull-to-Refresh:** Refresh the list of gists by pulling down on the table view.
- **Detailed View:** View detailed information about a gist in a new screen, including a web view of the gist's HTML content.
- **Error Handling:** Displays error messages when network requests fail.

## Architecture

- **MVVM (Model-View-ViewModel):** Separates concerns between data handling and UI rendering.
- **Combine:** Used for managing asynchronous events and data binding.
- **Kingfisher:** Handles image downloading and caching.

### Key Classes and Files

- `GistListViewController.swift`: Displays the list of gists.
- `GistDetailsViewController.swift`: Displays the details of a selected gist.
- `GistViewModel.swift`: Handles data fetching and state management.
- `GistAPIClient.swift`: Manages network requests to the GitHub API.
- `GistModel.swift`: Represents the gist data model.

## Testing

### Unit Tests

Unit tests are written using XCTest. To run the unit tests:

1. Open the project in Xcode.
2. Press `Cmd+U` to run all tests.

Example unit test:

```swift
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
        
        // Assert the state after fetchGists
        XCTAssertEqual(sut.state, .loading)
        XCTAssertEqual(sut.gistList, []) // Assuming gistList is initially empty
        
        // Simulate completion of network request
        mockNetworkClient.sendCompletion(.finished)
        
        // Assert the state and gistList after completion
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.gistList, mockGistList)
    }
}

// Mock NetworkClient for testing
class MockNetworkClient: ClientProtocol {
    var mockResponse: [GistModel]?
    
    func getClientData(page: Int) -> Future<[GistModel], DataError> {
        return Future { promise in
            if let mockResponse = self.mockResponse {
                promise(.success(mockResponse))
            } else {
                promise(.failure(DataError.networkError(description: "Mock Network Error")))
            }
        }
    }
}
```

### UI Tests

UI tests are written using XCTest. To run the UI tests:

1. Open the project in Xcode.
2. Press `Cmd+U` to run all tests.

Set accessibility identifiers to make UI elements easily identifiable in tests.

Example:

```swift
webView.accessibilityIdentifier = "gistWebView"
gistTableView.accessibilityIdentifier = "gistTableView"
```

## License

This project is currently not licensed. Please contact the repository owner if you wish to use any part of this code or have any questions regarding permissions and usage.
