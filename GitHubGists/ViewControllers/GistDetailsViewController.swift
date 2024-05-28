//
//  GistDetailsViewController.swift
//  GitHubGists
//
//  Created by Mauricio Lorenzetti on 27/05/24.
//

import UIKit
import WebKit

class GistDetailsViewController: UIViewController {
    
    var gist: GistModel?
    
    var activityIndicator: UIActivityIndicatorView!
    var webView: WKWebView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gist = gist {
            setupView(with: gist)
        } else {
            showErrorView()
        }
    }
    
    private func setupView(with gist: GistModel) {
        self.navigationItem.title = "\(gist.login)'s Gist Details"
        
        self.navigationController?.navigationBar.accessibilityIdentifier = "gistDetails"
        
        loginLabel.text = gist.login
        avatarImageView.configureForAvatar(with: gist.avatarURL)
        
        setupWebView(with: gist.htmlURL)
    }
    
    private func setupWebView(with url: URL) {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.isHidden = true
        
        webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        setupWebViewConstraints()
        webView.load(URLRequest(url: url))
    }
    
    private func setupWebViewConstraints() {
        let guide = view.safeAreaLayoutGuide
        webView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -20),
            activityIndicator.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            webView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            webView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            webView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    private func showErrorView() {
        self.navigationItem.title = "Error"
        let label = UILabel(frame: view.frame)
        label.text = "Error loading gist details. Try again."
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
    }
}

extension GistDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
}
