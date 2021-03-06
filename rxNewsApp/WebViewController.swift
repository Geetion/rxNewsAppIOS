//
//  WebViewController.swift
//
//
//  Created by Geetion on 15/10/6.
//
//

import UIKit
import WebKit
import Alamofire

@available(iOS 8.0, *)
class WebViewController: UIViewController,WKNavigationDelegate{
    var progressBar = UIProgressView()
    var webView: WKWebView!
    
    var from = String()
    let content = UITextView()
    let backView = UIView()
    var id = Int()
    let notifictionCenter = NSNotificationCenter.defaultCenter()
    
    override func loadView() {
        super.loadView()
        
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.webView = WKWebView(frame:self.view.frame)
        self.view.addSubview(webView)
        
        progressBar.progress = 0
        progressBar.frame = CGRect(x: 0, y: (self.view.frame.origin.y), width: self.view.frame.width, height: 20)
        progressBar.backgroundColor = UIColor.lightGrayColor()
        progressBar.progressTintColor = UIColor(red: 58/255.0, green: 168/255.0, blue: 252/255.0, alpha: 1.0)
        self.view.addSubview(progressBar)
        
        webView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        if from == "rx"{
            
            self.webView.frame.size = CGSize(width: WINDOW_WIDTH, height: WINDOW_HEIGHT - 40)
            
            backView.backgroundColor = UIColor(red: 28/255.0, green: 144/255.0, blue: 129/255.0, alpha: 1.0)
            backView.frame = CGRect(x: 0, y: WINDOW_HEIGHT - 104, width: WINDOW_WIDTH, height: 40)
            self.view.addSubview(backView)
            
            content.frame = CGRect(x: 8, y: 5, width: WINDOW_WIDTH - 90, height: 30)
            content.clipsToBounds = true
            content.layer.cornerRadius = 5
            backView.addSubview(content)
            
            
            let comment = UIButton()
            comment.setTitle("评论", forState: UIControlState.Normal)
            comment.backgroundColor = UIColor.whiteColor()
            comment.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            comment.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
            comment.frame = CGRect(x: WINDOW_WIDTH - 73, y: 5, width: 65, height: 30)
            comment.clipsToBounds = true
            comment.layer.cornerRadius = 5
            comment.addTarget(self, action: #selector(WebViewController.commitComment), forControlEvents: UIControlEvents.TouchUpInside)
            backView.addSubview(comment)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "评论页", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(WebViewController.pushToComment))
            
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        
        progressBar.setProgress(0.0, animated: false)
        
        self.showTabBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        notifictionCenter.addObserver(self, selector: #selector(WebViewController.keyboardDidShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        notifictionCenter.addObserver(self, selector: #selector(WebViewController.keyboardDidHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        var url = String()
        
        if from == "comment"{
            url = "http://app.ecjtu.net/api/v1/article/\(id)/comments"
        }else{
            url = "http://app.ecjtu.net/api/v1/article/\(id)/view"
        }
        
        let request = NSURLRequest(URL:NSURL(string:url)!)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        webView.loadRequest(request)
        
        
        self.hideTabBar()
    }
    
    func commitComment(){
        
        if content.text.characters.count != 0{
            postData()
        }else{
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "请输入评论内容", parentView: self.view)
        }
        
    }
    
    func postData(){
        
        if let account = userDefault.stringForKey("account"){

            let url = "http://app.ecjtu.net/api/v1/article/\(id)/comment"
            
            let param:[String:String] = ["sid":account,"content":content.text!]
            
            Alamofire.request(.POST, url, parameters: param, encoding: .URL, headers: nil).responseJSON(completionHandler: { (resp:Response<AnyObject, NSError>) -> Void in
                if resp.result.isSuccess{
                    self.content.resignFirstResponder()
                    self.content.text = ""
                    MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "评论成功", parentView: self.view)
                }else{
                    
                    MozTopAlertView.showWithType(MozAlertTypeError, text: "请检查网络", parentView: self.view)
                }
            })
        }else{
            MozTopAlertView.showWithType(MozAlertTypeError, text: "请先登录", parentView: self.view)
        }
    }
    
    func pushToComment(){
        
        let myWebViewController = WebViewController()
        
        myWebViewController.id = id
        myWebViewController.from = "comment"
        
        self.navigationController?.pushViewController(myWebViewController, animated: true)
        
    }
    
    //    点击页面取消焦点
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        content.resignFirstResponder()
    }
    
    //    KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            
            progressBar.hidden = webView.estimatedProgress == 1
            
            if webView.estimatedProgress == 1{
                
                UIView.animateWithDuration(1) { () -> Void in
                    self.webView.alpha = 1
                }
            }
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    func keyboardDidShow(notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo!
        
        let value = (userInfo.objectForKey("UIKeyboardFrameEndUserInfoKey")?.CGRectValue)! as CGRect
        
        backView.frame.origin.y = WINDOW_HEIGHT - 104 - value.height
    }
    
    func keyboardDidHide(notification:NSNotification){
    
        backView.frame.origin.y = WINDOW_HEIGHT - 104
    }
}

