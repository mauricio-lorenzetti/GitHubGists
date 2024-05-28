//
//  GistModel.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import Foundation

struct GistModel: Codable, Equatable {
    let filesCount: String
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    
    static func == (lhs: GistModel, rhs: GistModel) -> Bool {
        return lhs.filesCount == rhs.filesCount &&
               lhs.login == rhs.login &&
               lhs.avatarURL == rhs.avatarURL &&
               lhs.htmlURL == rhs.htmlURL
    }
}
