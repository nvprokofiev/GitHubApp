//
//  ViewRepositoryViewController.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-15.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit
import WebKit

class ViewRepositoryViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var urlString: String
    private var webView: WKWebView!
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.1
        return progressView
    }()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView(frame: .zero, configuration: injectedStriptConfiguration())
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebResource()
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupViews()
    }
    
    private func setupViews(){
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor),
        ])
    }
    
    private func loadWebResource(){
        guard let url = URL(string: urlString) else {
            print("Unable to get url from \(urlString)")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
    }

    private func injectedStriptConfiguration() -> WKWebViewConfiguration{
        let source = "document.body.style.background = \"#000\";"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        return configuration
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress == 1.0 {
                progressView.removeFromSuperview()
            }
        }
    }

}
