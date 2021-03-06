//
//  WebVC.swift
//  News
//
//  Created by Dzmitry Bosak on 9/6/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        
        setupWebView()
    }

    private func setupWebView() {
        progressView.progress = 0
        
        if let unwrappedURL = url {
            let request = URLRequest(url: unwrappedURL)
            webView.load(request)
            
            // Observer for progress view
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        }
    }
    
    // For ProgressView
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Actions for buttons
    
    private func openSafari() {
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    private func activityViewController() {
        
        guard let url = self.url else {
            return
        }
        
        let urlToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: urlToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - Actions
    
    @IBAction func openSafariButtonPressed(_ sender: Any) {
        openSafari()
    }
    
    @IBAction func actionsButtonPressed(_ sender: Any) {
        activityViewController()
    }
}

// MARK: - WKNavigationDelegate

extension WebVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
