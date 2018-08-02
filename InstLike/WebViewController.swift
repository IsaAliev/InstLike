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
    
    var onCsrfRetrieval: ((String, String) -> ())?
    
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
        
        
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
            var csrf: String?
            var sessionId: String?
            
            var cookiesString = ""
            
            for cookie in cookies {
                if cookie.name == "csrftoken" {
                    csrf = cookie.value
                }
                
                if cookie.name == "sessionid" {
                    sessionId = cookie.value
                }
                
                cookiesString.append("\(cookie.name)=\(cookie.value); ")
            }
            
            if let csrf = csrf, sessionId != nil {
                self.onCsrfRetrieval?(csrf, cookiesString)
            }
        }
        
        decisionHandler(.allow)
    }
    
    
    func retreiveCsrfIfPossible(_ response: URLResponse, completion: (String?, String?) -> ()) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return completion(nil, nil)
        }
        
        let headers = httpResponse.allHeaderFields
        
        guard let setCookies = headers["Set-Cookie"] as? String else {
            return completion(nil, nil)
        }
        
        let regexp = try? NSRegularExpression(pattern: "csrftoken=[^;]*", options: [])
        
        if let match = regexp?.firstMatch(in: setCookies, options: [], range: NSMakeRange(0, setCookies.count)) {
            let csrfTokenEntry = (setCookies as NSString).substring(with: match.range)
            
            let keyValue = csrfTokenEntry.split(separator: "=")
            
            if keyValue.count > 1 {
                completion(String(csrfTokenEntry.split(separator: "=")[1]), setCookies)
            }
        }
    }
}
