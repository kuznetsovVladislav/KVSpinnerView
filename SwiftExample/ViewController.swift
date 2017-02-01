//
//  ViewController.swift
//  Example Project
//
//  Created by Владислав  on 01.02.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var expectedContentLenght = 0
    var buffer = NSMutableData()
    var session: URLSession?
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func showSpinner(_ sender: Any) {
        KVSpinnerView.shared.show()
        
    }
    
    @IBAction func dismissSpinner(_ sender: Any) {
        KVSpinnerView.shared.dismiss()
    }
    
    @IBAction func downloadImageAction(_ sender: Any) {
        KVSpinnerView.shared.showWithProgress()
        realProgressExample()
    }
    
    @IBAction func downloadImageTextAction(_ sender: Any) {
        KVSpinnerView.shared.showWithProgress(saying: "Downloading image")
        realProgressExample()
    }
    
    fileprivate func realProgressExample() {
        let url = URL.init(
            string: "https://upload.wikimedia.org/wikipedia/commons/d/dd/Big_&_Small_Pumkins.JPG")
        let configuration = URLSessionConfiguration.default
        let mainQueue = OperationQueue.main
        session = URLSession(configuration: configuration,
                             delegate: self,
                             delegateQueue: mainQueue)
        
        dataTask = session?.dataTask(with: URLRequest(url: url!))
        dataTask?.resume()
        
    }
    
    fileprivate func fakeProgressExample() {
        KVSpinnerView.shared.showWithProgress()
        let time = DispatchTime.now() + .seconds(1)
        let time2 = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: time) {
            KVSpinnerView.shared.updateProgress(0.5)
        }
        DispatchQueue.main.asyncAfter(deadline: time2, execute: {
            KVSpinnerView.shared.updateProgress(1.0)
        })
    }
}

extension ViewController: URLSessionDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        expectedContentLenght = Int(response.expectedContentLength)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        let percentageDownloaded = CGFloat(buffer.length) / CGFloat(expectedContentLenght)
        KVSpinnerView.shared.updateProgress(percentageDownloaded)
    }
}

