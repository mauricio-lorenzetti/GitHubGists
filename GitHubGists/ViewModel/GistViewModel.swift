//
//  GistViewModel.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import Foundation
import Combine

protocol GistDelegate: AnyObject {
    func reloadData()
    func displayError(_ error: Error)
}

final class GistViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle {
       didSet {
           switch state {
           case .error(let error):
               self.gistDelegate?.displayError(error)
           default:
               break
           }
       }
   }
    
    var gistList = [GistModel]() {
        didSet {
            self.gistDelegate?.reloadData()
        }
    }
    
    var currentPage = 1
    
    var cancellable = Set<AnyCancellable>()
    let networkClient: ClientProtocol
    weak var gistDelegate: GistDelegate?
    
    init(networkClient: ClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchGists(page: Int = 1) {
        
        if case .loading = state { return }
        self.state = .loading
        
        networkClient.getClientData(page: page)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.state = .error(error)
                case .finished:
                    self.state = .loaded
                }
            } receiveValue: { [weak self] response in
                if page == 1 {
                    self?.gistList.removeAll()
                }
                self?.gistList.append(contentsOf: response)
                self?.currentPage = page
                self?.state = .loaded
            }
            .store(in: &cancellable)

    }
    
    func fetchNextPage() {
        fetchGists(page: currentPage + 1)
    }
    
}

extension GistViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case error(Error)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.loaded, .loaded):
                return true
            case (.error(let lhsError), .error(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
    }
}

