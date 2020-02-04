//
//  WebViewController.swift
//  colatour
//
//  Created by M6853 on 2018/3/12.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var url: String?
    var webViewTitle = ""
    var webView: WKWebView!
    var navLeftButtonType: NavLeftType = .defaultType
    private var isNeedToDimiss = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.webView = WKWebView.init(frame: CGRect.init(x: 0, y:0 , width: self.view.frame.width, height: self.view.frame.height),configuration: configuration)
        self.borderView.addSubview(webView)
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
        
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        self.progressView.tintColor = colorBorderBlue
        self.progressView.trackTintColor = UIColor.white
        
        self.webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if let urlString = self.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL.init(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            webView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTabBarType(tabBarType: .hidden)
        self.setNavBarItem(left: navLeftButtonType, mid: .textTitle, right: .nothing)
        self.setNavTitle(title: webViewTitle)
        super.viewWillAppear(animated)
        setNavigationItem()
    }
    
    func setNavigationItem(){
        
        let backImage = #imageLiteral(resourceName: "arrow_back_purple").withRenderingMode(.alwaysOriginal)
        let nextImage = #imageLiteral(resourceName: "arrow_next_purple").withRenderingMode(.alwaysOriginal)
        let closeImage = #imageLiteral(resourceName: "close").withRenderingMode(.alwaysOriginal)
        
        let back = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(self.goBack))
        let forward = UIBarButtonItem.init(image: nextImage, style: .plain, target: self, action: #selector(self.goForward))
        let close = UIBarButtonItem.init(image: closeImage, style: .plain, target: self, action: #selector(self.popView))
        if #available(iOS 11, *) {
            back.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            forward.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            close.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        }
        if self.webView.canGoBack == true{
            back.image = UIImage(named: "arrow_back_purple")
            back.isEnabled = true
        }else{
            back.image = UIImage(named: "arrow_back_gray")
            back.isEnabled = false
        }
        
        if self.webView.canGoForward == true{
            forward.image = UIImage(named: "arrow_next_purple")
            forward.isEnabled = true
        }else{
            forward.image = UIImage(named: "arrow_next_gray")
            forward.isEnabled = false
        }
        
        self.navigationItem.leftBarButtonItems = [back,forward]
        self.navigationItem.rightBarButtonItems = [close]
        self.setNavTitle(title: webViewTitle)
    }
    
    func setVCwith(url: String, title: String){
        self.url = url
        self.webViewTitle = title
    }

    func setDismissButton(){
        navLeftButtonType = .defaultType
        isNeedToDimiss = true
    }
    
    @objc func goBack(){
        self.webView.goBack()
    }
    
    @objc func goForward(){
        self.webView.goForward()
    }
    
    @objc func popView(){
        if isNeedToDimiss {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            progressView.setProgress(Float((self.webView?.estimatedProgress) ?? 0), animated: true)
            if (self.webView?.estimatedProgress ?? 0.0)  >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView?.uiDelegate = nil
        self.webView?.navigationDelegate = nil
    }
}

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        pringLog("decidePolicyFor navigationAction : \(navigationAction.request)")
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        pringLog("decidePolicyFor navigationResponse")
        
        if let responseUrl = navigationResponse.response.url{
            self.url = String(describing: responseUrl)
        }
        decisionHandler(.allow)

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        pringLog("didStartProvisionalNavigation")
        
        self.activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        pringLog("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        pringLog("didFailProvisionalNavigation : \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        pringLog("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pringLog("didFinish")
        
        setNavigationItem()
        self.activityIndicator.stopAnimating()
        
        //Note: 暫時用，記得之後刪除
        let hideHeaderScript = "document.getElementsByClassName(\"navbar navbar-default bk-w\")[0].style.display = \"none\""
        
        let hideToolBarTourScript = "document.getElementById(\"Div_ToolBar_Tour\").style.display = \"none\""
        
        let hideFooterScript = "document.getElementsByClassName(\"container footer-container\")[0].style.display = \"none\""

        webView.evaluateJavaScript(hideHeaderScript,
                                   completionHandler: nil)
        webView.evaluateJavaScript(hideToolBarTourScript,
                                   completionHandler: nil)
        webView.evaluateJavaScript(hideFooterScript,
                                   completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        pringLog("didFail : \(error.localizedDescription)")
        
        setNavigationItem()
        self.activityIndicator.stopAnimating()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        pringLog("webViewWebContentProcessDidTerminate")
    }
    
}

extension WebViewController : WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        pringLog("createWebViewWith : \(navigationAction.request)")
        
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            if let url = url {
                let request = URLRequest(url:url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
                
                let newWebView = WKWebView(frame: webView.frame, configuration: configuration)
                newWebView.load(request)
                newWebView.uiDelegate = self
                newWebView.navigationDelegate = self
                
                let vc = BaseViewController()
                vc.view.addSubview(newWebView)
                navigationController?.pushViewController(vc, animated: true)
                
                return newWebView
            }
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        pringLog("webViewDidClose")
    }
    
    //Note: 警告 javaScript視窗
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        pringLog("runJavaScriptAlertPanelWithMessage : \(message)")
        
        let alertSeverError:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: UIAlertAction.Style.default, handler: nil)
        alertSeverError.addAction(action)
        
        self.present(alertSeverError, animated: true)
        
        completionHandler()
    }
    
    //Note: 確認 javaScript視窗
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Note: 輸入 javaScript視窗
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension WebViewController {
    func pringLog(_ text: String){
        #if DEBUG
        print("======> \(text)")
        #endif
    }
}
