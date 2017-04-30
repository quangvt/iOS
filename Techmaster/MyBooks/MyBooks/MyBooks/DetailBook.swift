//
//  DetailBook.swift
//  MyBooks
//
//  Created by CanDang on 1/4/16.
//  Copyright © 2016 CanDang. All rights reserved.
//

import UIKit

class DetailBook: UIViewController {

    @IBOutlet weak var btnShowDate: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var myActive: UIActivityIndicatorView!
    @IBAction func action(_ sender: AnyObject)
    {
        self.webView.stringByEvaluatingJavaScript(from: "hello();")
    }
    var urlString : String = ""
    var type: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = urlString
//         set webview delegate
        self.webView.delegate = self
        
        // fit content within screen size.
        self.webView.scalesPageToFit = true
        
        // start spinner
        self.myActive.startAnimating()
        var urlpath = "default"
        // load url content within webview
        switch(type)
        {
            case "PDF" : urlpath = Bundle.main.path(forResource: urlString, ofType: "pdf")!
            self.btnShowDate.isHidden = true
            case "DOCX" : urlpath = Bundle.main.path(forResource: urlString, ofType: "docx")!
            self.btnShowDate.isHidden = true
            case "HTML" : urlpath = Bundle.main.path(forResource: urlString, ofType: "html")!
            self.btnShowDate.isHidden = false
            default : break
        }
        let url:URL = URL(fileURLWithPath: urlpath)
        //        if let urlToBrowse = NSURL.fileURLWithPath(urlpath!) {
        let urlRequest = URLRequest(url: url)
        self.webView.loadRequest(urlRequest)
        //        }
    }
}

extension DetailBook : UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.myActive.isHidden = true
        self.myActive.stopAnimating()
    }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print("")
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        print("")
        return true
    }
}
