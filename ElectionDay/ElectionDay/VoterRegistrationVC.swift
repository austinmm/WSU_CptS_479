//
//  ViewController.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/19/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit
import WebKit

class VoterRegistrationVC: UIViewController, WKUIDelegate
{
    let urlString = "https://www.vote.org/am-i-registered-to-vote/";
    var webView: WKWebView!;
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration();
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration);
        self.webView.uiDelegate = self;
        self.view = self.webView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: self.urlString);
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
}
