//
//  ClientProtocol.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import Foundation
import Combine

protocol ClientProtocol {
    func getClientData(page: Int) -> Future<[GistModel], DataError>
}
