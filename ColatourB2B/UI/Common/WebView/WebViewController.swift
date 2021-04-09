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
    
    let grayView = UIView()
    var expandableButtonView: ExpandableButtonView?
    private var lastContentOffset: CGFloat = 0
    
    var url: String?
    var webViewTitle = ""
    var webView: WKWebView!
    var navLeftButtonType: NavLeftType = .defaultType
    private var presenter: WebViewPresenterProtocol?
    private var isNeedToDimiss = false
    private var shareList: WebViewTourShareResponse.ItineraryShareData?
    private var popUpWebViews: [WKWebView] = []
    
    private var isFromExpandableButtonPopUpWebView = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = WebViewPresenter(delegate: self)
    }
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
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
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
        
        setUpGrayView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setTabBarType(tabBarType: .hidden)
        self.setNavBarItem(left: navLeftButtonType, mid: .textTitle, right: .nothing)
        self.setNavTitle(title: webViewTitle)
        super.viewWillAppear(animated)
        setNavigationItem()
    }
    
    func setNavigationItem(){
        
        let backImage = #imageLiteral(resourceName: "arrow_back_purple").withRenderingMode(.alwaysTemplate)
        let nextImage = #imageLiteral(resourceName: "arrow_next_purple").withRenderingMode(.alwaysTemplate)
        let closeImage = #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate)
        
        let back = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(self.goBack))
        let forward = UIBarButtonItem.init(image: nextImage, style: .plain, target: self, action: #selector(self.goForward))
        let close = UIBarButtonItem.init(image: closeImage, style: .plain, target: self, action: #selector(self.popView))
        
        if #available(iOS 11, *) {
            back.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            forward.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            close.imageInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
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
        
        grayView.alpha = 0
        
        if popUpWebViews.isEmpty == false {
            if popUpWebViews.last?.canGoBack == false {
                webViewDidClose( popUpWebViews.last!)
            } else {
                self.popUpWebViews.last?.goBack()
            }
            return
        }
        if webView.canGoBack == false {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.webView.goBack()
        }
    }
    
    @objc func goForward(){
        if popUpWebViews.isEmpty == false  {
            popUpWebViews.last?.goForward()
            return
        }
        self.webView.goForward()
    }
    
    @objc func popView(){
        if popUpWebViews.isEmpty == false  {
            webViewDidClose(popUpWebViews.last!)
            return
        }
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
    
    private func loadAndDisplayDocumentFrom(url downloadUrl : URL) {
        let localFileURL = FileManager.default.temporaryDirectory.appendingPathComponent(downloadUrl.lastPathComponent)
        
        URLSession.shared.dataTask(with: downloadUrl) { data, response, err in
            guard let data = data, err == nil else {
                debugPrint("Error while downloading document from url=\(downloadUrl.absoluteString): \(err.debugDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("Download http status=\(httpResponse.statusCode)")
            }
            
            do {
                try data.write(to: localFileURL, options: .atomic)
                debugPrint("Stored document from url=\(downloadUrl.absoluteString) in folder=\(localFileURL.absoluteString)")
                
                DispatchQueue.main.async {
                    let document = UIDocumentInteractionController(url: localFileURL)
                    document.delegate = self
                    document.presentPreview(animated: true)
                    
                }
            } catch {
                debugPrint(error)
                return
            }
        }.resume()
    }
    
    private func checkUrlToGetApi(url:URL?){
        var urlPathComponents = url?.pathComponents.joined(separator: "/")
        urlPathComponents?.removeFirst()
        let urlHost = url?.host
        let compareUrl = "\(urlHost ?? "")\(urlPathComponents ?? "")"
        let tourUrlDev = "ntestb2b.colatour.com.tw/R10T_TourSale/R10T13_TourItinerary.aspx"
        let tourUrlProd = "b2b.colatour.com.tw/R10T_TourSale/R10T13_TourItinerary.aspx"
        if compareUrl == tourUrlDev || compareUrl == tourUrlProd {
            if let tourCode = url?.valueOf("TourCode"), let tourDate = url?.valueOf("TourDate") {
                self.presenter?.getTourShareList(tourCode: tourCode, tourDate: tourDate)
                webView.scrollView.delegate = self
                popUpWebViews.last?.scrollView.delegate = self
            }
        } else {
            expandableButtonView?.isHidden = true
            webView.scrollView.delegate = nil
            popUpWebViews.last?.scrollView.delegate = nil
        }
    }
    
    @objc func onTouchGrayView() {
        
        expandableButtonView?.onTouchBaseButton()
    }

    func setUpGrayView() {
        
        grayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        grayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        grayView.alpha = 0
        grayView.isMultipleTouchEnabled = true
        grayView.isUserInteractionEnabled = true
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(onTouchGrayView))
        grayView.addGestureRecognizer(tapGes)
        
        var swipeGes = UISwipeGestureRecognizer()
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        directions.forEach {
            swipeGes = UISwipeGestureRecognizer(target: self, action: #selector(onTouchGrayView))
            swipeGes.direction = $0
            grayView.addGestureRecognizer(swipeGes)
        }
        
        view.addSubview(grayView)
    }
    
    func setUpExpandableButtonView(shareList: WebViewTourShareResponse.ItineraryShareData) {
        
        for duplicateView in view.subviews {
            if duplicateView is ExpandableButtonView {
                duplicateView.removeFromSuperview()
            }
        }
        
        let navHieght = self.navigationController?.navigationBar.frame.height ?? 44
        expandableButtonView = ExpandableButtonView(frame: CGRect(x: screenWidth - 75, y: screenHeight - statusBarHeight - navHieght - 220, width: 56, height: 256))
        expandableButtonView?.delegate = self
        expandableButtonView?.setUpButtons(shareList: shareList)
        
        if let view = expandableButtonView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.addSubview(view)
            }
        }
    }
    
    func shareInfo() {
        
        let items = "\(shareList?.shareInfo ?? "")\n\(shareList?.shareUrl ?? "")\n\n\(shareList?.contactInfo ?? "")"
        let activityVC = UIActivityViewController(activityItems: [items], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension WebViewController: ExpandableButtonViewDelegate {

    func webViewTurnGraySwitch() {
        
        grayView.alpha = (grayView.alpha == 0) ? 1 : 0
    }
    
    func didTapExpandableButton(buttonType: ExpandableButtonType, url: URL) {
        
        switch buttonType {
        case .Share:
            shareInfo()
            
        case .Forward, .Booking:
            if popUpWebViews.isEmpty == false {
                popUpWebViews.last?.load(URLRequest(url: url))
                isFromExpandableButtonPopUpWebView = true
                return
            }
            isFromExpandableButtonPopUpWebView = false
            webView.load(URLRequest(url: url))
        
        }
            
    }
}

extension WebViewController : WebViewProtocol {
    func onBindTourShareList(shareList: WebViewTourShareResponse.ItineraryShareData) {
        self.shareList = shareList
        setUpExpandableButtonView(shareList: shareList)
        expandableButtonView?.isHidden = false
    }
}

extension WebViewController : UIDocumentInteractionControllerDelegate{
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController{
        return self
    }
}

extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        pringLog("decidePolicyFor navigationAction : \(navigationAction.request)")
        let url = navigationAction.request.url
        
        if url?.pathExtension == "doc" || url?.pathExtension == "pdf" || url?.pathExtension == "docx" {
            loadAndDisplayDocumentFrom(url: url!)
            decisionHandler(.cancel)
        }else{
            decisionHandler(.allow)
        }
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
        self.webViewTitle = self.webView.title!
        setNavigationItem()
        if popUpWebViews.isEmpty == false {
            checkUrlToGetApi(url: popUpWebViews.last?.url)
        }else{
            checkUrlToGetApi(url: self.webView.url)
        }
        self.activityIndicator.stopAnimating()
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
            if url?.pathExtension == "doc" || url?.pathExtension == "pdf" || url?.pathExtension == "docx" {
                loadAndDisplayDocumentFrom(url: url!)
            } else {
                
                let popUpWebView = WKWebView(frame: webView.frame, configuration: configuration)
                popUpWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                popUpWebView.uiDelegate = self
                popUpWebView.navigationDelegate = self
                view.addSubview(popUpWebView)
                view.bringSubviewToFront(grayView)
                popUpWebViews.append(popUpWebView)
                return popUpWebViews.last!
            }
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        pringLog("webViewDidClose")
        if popUpWebViews.last?.canGoBack == true && isFromExpandableButtonPopUpWebView {
            goBack()
            
        }else{
            popUpWebViews.removeLast()
            webView.removeFromSuperview()
            
        }
        checkUrlToGetApi(url: self.webView.url)
    }
    
    //Note: 警告 javaScript視窗
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        pringLog("runJavaScriptAlertPanelWithMessage : \(message)")
        
        let alertSeverError:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: UIAlertAction.Style.default, handler: { action in
            completionHandler()
        })
        alertSeverError.addAction(action)
        
        self.present(alertSeverError, animated: true)
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

extension WebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 { return }
        
        expandableButtonView?.isHidden = lastContentOffset < scrollView.contentOffset.y
        lastContentOffset = scrollView.contentOffset.y
    }
}

extension WebViewController {
    func pringLog(_ text: String){
        #if DEBUG
        print("======> \(text)")
        #endif
    }
}
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
