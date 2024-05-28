//
//  ViewController.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import UIKit
import Kingfisher
import Combine

class GistListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gistTableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel = GistViewModel(networkClient: GistAPIClient())
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Latest Gists"
        
        gistTableView.register(UINib(nibName: "GistCell", bundle: .main), forCellReuseIdentifier: "GistCell")
        gistTableView.register(UINib(nibName: "LoadMoreCell", bundle: .main), forCellReuseIdentifier: "LoadMoreCell")
        
        self.gistTableView.dataSource = self
        self.gistTableView.delegate = self
        
        self.gistTableView.accessibilityIdentifier = "gistTableView"
        
        // Activity indicator for gist loading
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        
        gistTableView.backgroundView = activityIndicator
        
        viewModel.gistDelegate = self
        viewModel.fetchGists()
        
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .error(let error):
                    self?.displayError(error)
                case .loaded:
                    self?.activityIndicator?.stopAnimating()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case .loaded = viewModel.state {
            return viewModel.gistList.count + 1
        }
        return viewModel.gistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.gistList.count {
            let cell = gistTableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
            cell.accessibilityIdentifier = "gistCell_\(indexPath.row)"
            let gist = viewModel.gistList[indexPath.row]
            let suffix = Int(gist.filesCount)! > 1 ? "s" : " "
            cell.loginLabel.text = gist.login
            cell.filesCountLabel.text = "\(gist.filesCount) file".appending(suffix)
            cell.avatarImageView.configureForAvatar(with: gist.avatarURL)
            return cell
        } else {
            let cell = gistTableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : GistDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GistDetailsViewController") as! GistDetailsViewController
        vc.gist = viewModel.gistList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Infinite scroll logic
        if offsetY > contentHeight - height + 100 {
            viewModel.fetchNextPage()
        }
        
        // Pull-to-refresh logic
        if offsetY < -100 {
            if case .loading = viewModel.state {
                return
            }
            viewModel.fetchGists()
        }
        
    }
}

extension GistListViewController: GistDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.gistTableView.reloadData()
        }
    }
    
    func displayError(_ error: Error) {
        DispatchQueue.main.async {
            self.gistTableView.removeFromSuperview()
            let label = UILabel(frame: self.view.frame.insetBy(dx: 32.0, dy: 32.0))
            label.text = "Internal Error: \(error.localizedDescription)"
            label.numberOfLines = 0
            label.textAlignment = .center
            self.view.addSubview(label)
        }
    }
}

