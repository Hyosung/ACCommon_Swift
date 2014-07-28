//
//  ACNetworking.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-25.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import Foundation

let kACHTTPRequestBaseURLString: NSString = ""

let kACASIRequestFinishKey      = "kACASIRequestFinishKey"
let kACASINetworkQueueFinishKey = "kACASINetworkQueueFinishKey"

typealias ACCompleteCallback        = (result: NSDictionary!, error: NSError!) -> Void
typealias ACUploadCallback          = (totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) -> Void
typealias ACDownloadCallback        = (size: Int64, total: UInt64) -> Void
typealias ACQueueCompleteCallback   = () -> Void
typealias ACRequestCompleteCallback = (request: ASIHTTPRequest!, result: NSDictionary!, error: NSError!) -> Void

extension ACNetworking {
    class func requestWithURLString(var theURLString: NSString!, var method: NSString!, var params: Dictionary<NSString, NSString>!) -> ASIHTTPRequest! {
        assert((method && method.isKindOfClass(NSClassFromString("NSString"))), "网络请求方式不正确");
        
        if !theURLString || !theURLString.isKindOfClass(NSClassFromString("NSString")) {
            theURLString = ""
        }
        
        method = method.uppercaseString
        var encodeURLString: NSString = theURLString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var baseURL: NSURL = NSURL.URLWithString(kACHTTPRequestBaseURLString)
        var tempURL: NSURL = NSURL.URLWithString(encodeURLString, relativeToURL: baseURL)
        
        var request: ASIHTTPRequest = ASIHTTPRequest.requestWithURL(tempURL) as ASIHTTPRequest
        request.requestMethod = method
        
        if !params.isEmpty {
            
            if method.isEqualToString("GET") || method.isEqualToString("HEAD") || method.isEqualToString("DELETE") {
                
                var paramsArray: NSMutableArray = NSMutableArray.array()
                
                for (value, key) in params {
                    paramsArray.addObject(value + "=" + key)
                }
                
                var absoluteString: NSMutableString = NSMutableString.stringWithString(tempURL.absoluteString)
                var aRange:NSRange = absoluteString.rangeOfString("?")
                
                var urlString: NSString = tempURL.absoluteString.stringByAppendingFormat((aRange.location == Foundation.NSNotFound ? "?%@" : "&%@"), paramsArray.componentsJoinedByString("&")).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                
                tempURL = NSURL.URLWithString(urlString)
                
                request.url = tempURL
            }
            else if method.isEqualToString("POST") {
                
                request = ASIHTTPRequest.requestWithURL(tempURL) as ASIHTTPRequest
                
                for (value, key) in params {
                    (request as ASIFormDataRequest).setPostValue(value, forKey: key)
                }
            }
            else {
                //                ACLog(@"其他请求暂不处理");
            }
        }
        return request
    }
}

class ACNetworking: NSObject {
    
    deinit {
        
    }
    
    class func startACASIHTTPRequestWithParams(params: Dictionary<NSString, NSString>!, method: NSString!, complete callback: ACCompleteCallback!) {
        var request: ASIHTTPRequest = ACNetworking.requestWithURLString(nil, method: method, params: params)
        request.setCompletionBlock({
            if callback {
                var error: NSError?
                var result: AnyObject! = NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableLeaves, error: &error)
                callback(result: result as NSDictionary, error: error!)
            }
            request.clearDelegatesAndCancel()
            })
        
        request.setFailedBlock({
            if callback {
                callback(result: nil, error: request.error)
            }
            request.clearDelegatesAndCancel()
            })
        request.startAsynchronous()
    }
    
    class func startACASIHTTPPostRequestWithParams(params: Dictionary<NSString, NSString>!, complete callback: ACCompleteCallback!) {
        ACNetworking.startACASIHTTPRequestWithParams(params, method: "POST", complete: callback)
    }
    
    class func startACASIHTTPGetRequestWithParams(params: Dictionary<NSString, NSString>!, complete callback: ACCompleteCallback!) {
        
        ACNetworking.startACASIHTTPRequestWithParams(params, method: "GET", complete: callback)
    }
    
    class func startACASIHTTPUploadWithParams(params: Dictionary<NSString, NSString>!, fileKeys: NSArray!, fileValues: NSArray!, complete completeCallback: ACCompleteCallback!, download downloadCallback: ACDownloadCallback!) {
    }
    
    class func startACASIHTTPDownloadWithURLString(urlString: NSString, complete completeCallback: ACCompleteCallback!, download downloadCallback: ACDownloadCallback!) {
        var request: ASIHTTPRequest = ACNetworking.requestWithURLString(urlString, method: "GET", params: nil)
        request.allowResumeForFileDownloads = true
        request.downloadDestinationPath = kAppCaches.stringByAppendingPathComponent("ACDownload")
        request.temporaryFileDownloadPath = fAppTmpAddTo("ACTemp")
        request.setCompletionBlock({
            if completeCallback {
                var error: NSError?
                var result: AnyObject! = NSJSONSerialization.JSONObjectWithData(request.responseData(), options: NSJSONReadingOptions.MutableLeaves, error: &error)
                completeCallback(result: result as NSDictionary, error: error)
            }
            request.clearDelegatesAndCancel()
            })

        request.setFailedBlock({
            if completeCallback {
                completeCallback(result: nil, error: request.error)
            }
            request.clearDelegatesAndCancel()
            })
        
        request.setDownloadSizeIncrementedBlock({
            (size: Int64) -> Void in
            if downloadCallback {
                downloadCallback(size: size, total: request.partialDownloadSize)
            }
            })
        request.startAsynchronous()
    }
    
    
    /**
    首先调用这两个方法
    */
    class func requestLoadingFinish(requestBlock: ACRequestCompleteCallback!) {
        objc_setAssociatedObject(self, kACASIRequestFinishKey, requestBlock, UInt(OBJC_ASSOCIATION_COPY));
    }
    
    class func queueLoadingFinish(queueBlock: ACQueueCompleteCallback!) {
       
    }
    
    /**
    其次才使用这个方法
    */
    class func appendRequestToNetworkQueueWithParams(params: NSDictionary!, urlString: NSString!, method: NSString!) {
        
    }
    
    class func startACAFNHTTPRequestWithParams(params: NSString!, method: NSString!, complete: ACCompleteCallback!) {
        
    }
    
    class func startACAFNHTTPPostRequestWithParams(params: NSDictionary!, complete: ACCompleteCallback!) {
            
    }
    
    class func startACAFNHTTPGetRequestWithParams(params: NSDictionary!, complete: ACCompleteCallback!) {
        
    }
    
    class func startACAFNHTTPUploadWithParams(params: NSDictionary!, fileKeys: NSArray!, fileValues: NSArray!, complete: ACCompleteCallback!, upload:ACUploadCallback!) {
        
    }
    
    class func startACAFNHTTPDownloadWithURLString(urlString: NSString, complete: ACCompleteCallback!, download: ACDownloadCallback!) {
        
    }
}
