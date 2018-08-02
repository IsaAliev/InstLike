//
//  MainController.swift
//  InstLike
//
//  Created by Isa Aliev on 02.08.2018.
//  Copyright © 2018 Isa Aliev. All rights reserved.
//

import UIKit
import WebKit

class MainController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var refToRequestField: UITextField!
    
    var session: URLSession!
    
    @IBAction func loginButtonAction() {
        presentLogIn()
    }
    
    func presentLogIn() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController

        controller.onCookiesRetrieval = { token, cookie in
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
        let url = URL(string: refToRequestField.text ?? "")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "x-csrftoken": token,
            "cookie": cookie
        ]
        
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.statusLabel.text = "Done"
            }
        }.resume()
    }
}

