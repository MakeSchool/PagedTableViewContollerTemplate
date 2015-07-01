//  Make School Template App
//  WebViewController.swift


import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var activeDownloads = 0
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    var url: NSURL? {
        didSet{
            if view.window != nil{
                loadURL()
            }
        }
    }
    
    
    private func loadURL(){
        if url != nil{
            webView.loadRequest(NSURLRequest(URL:url!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scalesPageToFit = true
        webView.delegate = self
        loadURL()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activeDownloads++
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activeDownloads--
        if activeDownloads < 1 {
            spinner.stopAnimating()
   
        }
    }
    
}