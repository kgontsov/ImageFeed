//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Kirill Gontsov on 27.07.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    let showWebViewSegueIdentifier = "ShowWebView"
    
    @IBOutlet private var webView: WKWebView!
    
}
