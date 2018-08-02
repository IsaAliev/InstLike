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
        retreiveCsrfIfPossible(navigationResponse.response) { csrf, cookie in
            if let token = csrf {
                onCsrfRetrieval?(token, cookie!)
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
