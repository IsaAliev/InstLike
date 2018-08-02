//
//  WebViewController.swift
//  InstLike
//
//  Created by Isa Aliev on 02.08.2018.
//  Copyright © 2018 Isa Aliev. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var onCookiesRetrieval: ((String, String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "https://instagram.com/") else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] (cookies) in
            self?.checkCookiesAndPassIfPossible(cookies)
        }
        
        decisionHandler(.allow)
    }
    
    func checkCookiesAndPassIfPossible(_ cookies: [HTTPCookie]) {
        var csrf: String?
        var sessionId: String?
        
        var cookiesString = ""
        
        for cookie in cookies {
            let cookieName = cookie.name
            
            if cookieName == "csrftoken" {
                csrf = cookie.value
            }
            
            if cookieName == "sessionid" {
                sessionId = cookie.value
            }
            
            cookiesString.append("\(cookie.name)=\(cookie.value); ")
        }
        
        if let csrf = csrf, sessionId != nil {
            self.onCookiesRetrieval?(csrf, cookiesString)
        }
    }
}
