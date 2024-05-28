//
//  GistAPIClient.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import Foundation
import Combine

class GistAPIClient: ClientProtocol {
    
    var cancellable = Set<AnyCancellable>()
    
    func getClientData(page: Int = 0) -> Future<[GistModel], DataError> {
        
        return Future { promise in
            
            guard let url = URL(string: publicGistsURL + "?page=\(page)") else {
                return promise(.failure(.networkError(description: "Invalid URL")))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) in
                    guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                        throw DataError.networkError(description: "Invalid HTTP response")
                    }
                    return data
                }
                .tryMap { (data:Data) in
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            var gistList:[GistModel] = []
                            for gist in jsonObject {
                                gistList.append(
                                    GistModel(filesCount: String((gist["files"] as! [String: Any]).count),
                                              login: (gist["owner"] as! [String:Any])["login"] as! String,
                                              avatarURL: URL(string:(gist["owner"] as! [String:Any])["avatar_url"] as! String)!,
                                              htmlURL: URL(string:(gist["html_url"] as! String))!)
                                )
                            }
                            return gistList
                        }
                        throw DataError.parsingError(description: "JSON malformed")
                    } catch {
                        throw DataError.parsingError(description: "Error parsing data")
                    }
                }
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case _ as DecodingError:
                            promise(.failure(.parsingError(description: "Error parsing data")))
                        default:
                            promise(.failure(.networkError(description: "Error fetching data")))
                        }
                    }
                } receiveValue: { response in
                    return promise(.success(response))
                }
                .store(in: &self.cancellable)
        }
    }
}
