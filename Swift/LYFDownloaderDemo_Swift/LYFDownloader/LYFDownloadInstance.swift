//
//  LYFDownloadInstance.swift
//  LYFDownloaderDemo_Swift
//
//  Created by 罗元丰 on 2017/3/23.
//  Copyright © 2017年 罗元丰. All rights reserved.
//

import UIKit

enum LYFDownloadTaskState {
    case Downloading
    case Waiting
    case Paused
    case Error
}

class LYFDownloadInstance: NSObject, URLSessionDownloadDelegate {
    
    private var resumeData:     Data?
    private var request:        URLRequest?
    private var session:        URLSession?
    private var downloadTask:   URLSessionDownloadTask?
    private var config:         URLSessionConfiguration?
    
    var customKey:      String!
    var urlString:      String!
    var baseFilePath:   String!
    var filePath:       String?
    var speedTimer:     Timer!
    var speed:          Int64?
    var failCount:      Int8?
    var isProduce:      Bool?
    
    var kRequestTimeout: TimeInterval = 30.0
    
    override init() {
        print("init() cannot init LYFDownloadInstance correctly, use init(urlString: customKey: rootFolder:) instead")
        super.init()
    }
    
    public init(urlString: String, customKey: String, rootFolder: Int) {

        super.init()
        
        self.urlString = urlString
        self.customKey = customKey
        if rootFolder == 0 {
            self.baseFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last;
        } else {
            self.baseFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last;
        }
        
        self.speedTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(LYFDownloadInstance.getCurrentSpeed), userInfo: nil, repeats: true)
        self.config = URLSessionConfiguration.init()
        self.config?.sessionSendsLaunchEvents = true
        self.config?.isDiscretionary = false;
        self.config?.timeoutIntervalForRequest = kRequestTimeout
        
        self.session = URLSession.init(configuration: self.config!, delegate: self, delegateQueue: .main)
        self.downloadTask = self.session?.downloadTask(with: URLRequest.init(url: URL.init(string: self.urlString!)!))
    }
    
    //MARK: - URLSessionDownloadDelegate
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        let desPath = self.baseFilePath!.appendingFormat("/%@", <#T##arguments: CVarArg...##CVarArg#>)
    }
    
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    //MARK: - public
    public func start() -> Void {
        if self.downloadTask?.state == .suspended {
            self.downloadTask?.resume()
            self.resumeIfNeeded()
        }
    }
    
    public func pause() ->Void {
        if self.downloadTask?.state == .running {
            self.downloadTask?.suspend()
        }
    }
    
    public func cancel() ->Void {
        if self.downloadTask?.state != .canceling {
            self.downloadTask?.cancel()
        }
    }
    
    public func cancelbyProduceResumeData() -> Void {
        if self.downloadTask?.state != .canceling {
            self.downloadTask?.cancel(byProducingResumeData: { (resumeData: Data?) in
                self.resumeData = resumeData;
            })
        }
    }
    
    
    //MARK: - private
    internal func getCurrentSpeed() -> Void {
        
    }
    
    internal func resumeIfNeeded() -> Void {
        
    }
}
