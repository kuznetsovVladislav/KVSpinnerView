//
//  ImageManager.swift
//  KVSpinnerView
//
//  Created by Владислав  on 07.02.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit


class NetworkManager: NSObject {
    
    typealias DownloadCompletion = (_ image: UIImage?) -> Void
    typealias DownloadProgress = (_ progress: Progress) -> Void
    
    var downloadCompletion: DownloadCompletion?
    var progressHandler: DownloadProgress?
    
    func downloadImage() {
        let endpoint = "http://eoimages.gsfc.nasa.gov/images/imagerecords/78000/78314/VIIRS_3Feb2012_lrg.jpg"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }
}

extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
    	let progress = Progress(totalUnitCount: totalBytesExpectedToWrite)
        progress.completedUnitCount = totalBytesWritten
        DispatchQueue.main.async {
            self.progressHandler!(progress)
        }
    }
}

extension NetworkManager: URLSessionDownloadDelegate {

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = NSData(contentsOf: location), let image = UIImage(data: data as Data) {
            DispatchQueue.main.async {
                self.downloadCompletion!(image)
            }
        } else {
            print("Cannot load the image")
            downloadCompletion!(nil)
        }
    }
}
