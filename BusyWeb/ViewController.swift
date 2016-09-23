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

class ViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {
/*
    enum searchBarState {
        
        case hidden, notHidden
        
    }
  */
    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var webContainer: UIView!
    
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toolBarView: UIToolbar!
    
    @IBOutlet weak var urlButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureOutput?
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupSession()
        
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false

        setupSearchBar()
    }

    
    override func viewDidAppear(_ animated: Bool) {
       
    

        webView = WKWebView()
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.webView.navigationDelegate = self
        searchBar.delegate = self
        webView.frame = CGRect(x: 0, y: 0, width: webContainer.frame.width, height: webContainer.frame.height - (toolBarView.frame.height + progressBar.frame.height))
        print(webView.frame.height)
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
 
    func setupSearchBar(){
        print("do nothing")
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
    
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
    
    /*
    @IBAction func refresh(_ sender: AnyObject) {
        //webView.reload()
        let request = URLRequest(url:webView.url!)
        webView.load(request)
    }*/
    
    @IBAction func urlButtonPressed(_ sender: AnyObject) {
        
        if(searchBar.isHidden){
            searchBar.isHidden = false
            searchBar.becomeFirstResponder()
        }
        else{
            searchBar.isHidden = true
        }
    }
    
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
            searchBar.resignFirstResponder()
            let text = "http://" + searchBar.text!
            let url = URL(string: text)
            let req = URLRequest(url: url!)
            webView!.load(req)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.5, animations: {
                searchBar.sizeToFit()
            }
        )
        searchBar.showsCancelButton = true

        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.5, animations: {
            var searchBarFrame = searchBar.frame
            searchBarFrame.size.height = 22
            searchBar.frame = searchBarFrame
            }
        )
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    
    /*
    func updateUI(for state: AudioState){
        switch(state){
        case .Stopped:
            recordButton.enabled = true
            stopButton.enabled = false
        case .Recording:
            recordButton.enabled = false
            stopButton.enabled = true
        default:
            break
        }
    }
    */


}

