//
//  ViewController.swift
//  BusyWeb
//
//  Created by Daniel Song on 9/19/16.
//  Copyright © 2016 Daniel Song. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var webContainer: UIView!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var toolBarView: UIToolbar!
    
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureOutput?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
    }
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
    

        webView = WKWebView()
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.navigationDelegate = self

        webView.frame = CGRect(x: 0, y: 0, width: webContainer.frame.width, height: 621)
        webContainer.insertSubview(webView, aboveSubview: progressBar)


        
        /*let url = NSURL(string:"http://www.google.com")
        let req = NSURLRequest(url:url! as URL)
        self.webView!.load(req as URLRequest)
        */
        
        let url = URL(string:"http://www.google.com")
        let req = URLRequest(url:url!)
        self.webView!.load(req)

 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func setupSession(){
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
        input = try AVCaptureDeviceInput(device: device)
        session?.addInput(input)
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = cameraContainer.bounds
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraContainer.layer.addSublayer(previewLayer)
        
        
        session?.startRunning()
        
    }
 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ( keyPath == "loading"){
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
        }
        if ( keyPath == "estimatedProgress"){
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    
    /*
    @IBAction func refresh(_ sender: AnyObject) {
        //webView.reload()
        let request = URLRequest(url:webView.url!)
        webView.load(request)
    }*/
    @IBAction func back(_ sender: AnyObject) {
        webView.goBack()
    }
   
    @IBAction func forward(_ sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func slider(_ sender: UISlider) {
        let transparency = sender.value
        webContainer.alpha = CGFloat(transparency)
    
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated:true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar.setProgress(0.0, animated: false)
    }
    
    
   /* func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    urlField.resignFirstResponder()
    var textFieldRequest = URLRequest(url: URL(string: textField.text!)!)
    webView.load(textFieldRequest)
    return false
    }
*/
}

