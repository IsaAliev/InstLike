//
//  ViewController.swift
//  InstLike
//
//  Created by Isa Aliev on 02.08.2018.
//  Copyright © 2018 Isa Aliev. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.presentLogIn()
        }
    }
    
    func presentLogIn() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.onCsrfRetrieval = { token, cookie in
            DispatchQueue.main.async {
                self.processToken(token, cookie: cookie)
            }
        }
        
        present(controller, animated: true, completion: nil)
    }
    
    func processToken(_ token: String, cookie: String) {
        self.dismiss(animated: true, completion: nil)
        self.statusLabel.text = "Liking post ..."
        
        session = URLSession(configuration: URLSessionConfiguration.default)
        
        let url = URL(string: "https://www.instagram.com/web/likes/1837012079456663119/like/")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
         request.allHTTPHeaderFields = [
            "x-csrftoken": token,
            "cookie": cookie,
            "x-instagram-ajax":"1"
//            "accept-language":"ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7",
//            "x-csrftoken": "DLWt1lgcdPkzCGtAh8LyeqIId7AfF7iT",
//            "x-instagram-ajax":"1",
//            "content-type":"application/x-www-form-urlencoded",
//            "content-length":"0",
//            "accept-encoding":"gzip, deflate, br",
//            "accept":"*/*",
//            "cookie": "mid=W2LvzAAEAAGlZ4PFfhChqTLxH0PA; mcd=3; csrftoken=DLWt1lgcdPkzCGtAh8LyeqIId7AfF7iT; shbid=4297; ds_user_id=5444624778; sessionid=IGSC5fa178a064e99c0c91d57d9b06c318c3eb7221230439ad920bc4cec1f0d6a268%3AqnuXb2xklzFNbZTv5KcOOeKORsjEAgJA%3A%7B%22_auth_user_id%22%3A5444624778%2C%22_auth_user_backend%22%3A%22accounts.backends.CaseInsensitiveModelBackend%22%2C%22_auth_user_hash%22%3A%22%22%2C%22_platform%22%3A4%2C%22_token_ver%22%3A2%2C%22_token%22%3A%225444624778%3AD0jmUnVlhO4oE5xG10BkhppYnrh3u6Fr%3A23985bfb3b4216b57ad09df269c61bd6dc4e6de80f17b0cd4fc7a6970975f203%22%2C%22last_refreshed%22%3A1533210591.4683718681%7D; rur=ATN; urlgen=\"{\"time\": 1533210572\054 \"37.16.83.2\": 31261}:1flDT2:W3MFzJ8--VOUYwmiX_T2xYIXt38\"",
//
//            "origin":"https://www.instagram.com",
//            "referer":"https://www.instagram.com/",
//            "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36",
//            "x-requested-with":"XMLHttpRequest"
        ]
        
        
        session.dataTask(with: request) { (data, response, error) in
            print((data, response, error))
            DispatchQueue.main.async {
                self.statusLabel.text = "Done"
            }
        }
    }
}

