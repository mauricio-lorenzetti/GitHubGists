//
//  DataError.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import Foundation

enum DataError: Error {
    case networkError(description: String)
    case parsingError(description: String)
    case fileError(description: String)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let description),
             .parsingError(let description),
             .fileError(let description):
            return description
        }
    }
}
