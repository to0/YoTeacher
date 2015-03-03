//
//  NetworkRequest.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-17.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation
import UIKit

class NetworkRequest: NSObject {
    
    class func userLogin(userID: String, password: String, responser: ResponseProtocol) {
        let host = APIInfo.HOST
        let action = APIInfo.LOGIN
        let url = NSURL(string: (host + action))
        let data = ["username": userID, "password": password]
        post(url!, action: action, data: data, responser: responser)
    }
    
    class func getMyInfo(token: String, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.GETMYINFO)?\(JSONName.token)=\(token)")
        get(url!, action: APIInfo.GETMYINFO, responser: responser)
    }
    
    class func updateStatus(token: String, status: Int, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.UPDATESTATUS)?\(JSONName.token)=\(token)&iffree=\(status)")
        get(url!, action: APIInfo.UPDATESTATUS, responser: responser)
    }
    
    class func getTakeMissions(token: String, uid: Int, start: Int?, limit: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetTakeMissions)?\(JSONName.token)=\(token)&\(JSONName.uid)=\(uid)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetTakeMissions, responser: responser)
    }
    
    class func getMissions(token: String, start: Int?, limit: Int?, status: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetMissions)?\(JSONName.token)=\(token)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        if (status != nil) {
            urlStr += "&\(JSONName.status)=\(status!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetMissions, responser: responser)
    }
    
    class func getTeacherEvaluations(tid: Int, start: Int?, limit: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetTeacherEvaluations)?\(JSONName.tid)=\(tid)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetTeacherEvaluations, responser: responser)
    }
    
    class func getMyTopics(token: String, start: Int?, limit: Int?, status: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetMyTopics)?\(JSONName.token)=\(token)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        if (status != nil) {
            urlStr += "&\(JSONName.status)=\(status!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetMyTopics, responser: responser)
    }
    
    class func setPassword(token: String, oldPwd: String, newPwd: String, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.SetPassword)?")
        let data = [JSONName.token: token, JSONName.oldPassword: oldPwd, JSONName.newPassword: newPwd]
        post(url!, action: APIInfo.SetPassword, data: data, responser: responser)
    }
    
    class func confirmMission(token: String, mid: Int, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.ConfirmMission)?\(JSONName.token)=\(token)&\(JSONName.mid)=\(mid)")
        get(url!, action: APIInfo.ConfirmMission, responser: responser)
    }
    
    class func getAddMissions(token: String, uid: Int, start: Int?, limit: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetAddMissions)?\(JSONName.token)=\(token)&\(JSONName.uid)=\(uid)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetAddMissions, responser: responser)
    }
    
    class func getTopicTemplate(token: String, lang: Int, start: Int?, limit: Int?, responser: ResponseProtocol) {
        var urlStr = "\(APIInfo.HOST)\(APIInfo.GetTopicTemplate)?\(JSONName.token)=\(token)&\(JSONName.lang)=\(lang)"
        if (start != nil) {
            urlStr += "&\(JSONName.start)=\(start!)"
        }
        if (limit != nil) {
            urlStr += "&\(JSONName.limit)=\(limit!)"
        }
        
        let url = NSURL(string: urlStr)
        get(url!, action: APIInfo.GetTopicTemplate, responser: responser)
    }
    
    class func setTwitter(token: String, twitter: String, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.SetTwitter)?")
        let data = [JSONName.token: token, JSONName.twitter: twitter]
        post(url!, action: APIInfo.SetTwitter, data: data, responser: responser)
    }
    
    class func setTopic(token: String, id: Int, charge: Double, duration: Int, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.SetTopic)?")
        let data = [JSONName.token: token, JSONName.id: "\(id)", JSONName.charge: "\(charge)", JSONName.duration: "\(duration)"]
        post(url!, action: APIInfo.SetTopic, data: data, responser: responser)
    }
    
    class func addTopic(token: String, tid: Int, ttid: Int, charge: Double, duration: Int, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.AddTopic)?")
        let data = [JSONName.token: token, JSONName.tid: "\(tid)", JSONName.ttid: "\(ttid)", JSONName.charge: "\(charge)", JSONName.duration: "\(duration)"]
        post(url!, action: APIInfo.AddTopic, data: data, responser: responser)
    }
    
    class func evaluateStudent(token: String, mid: Int, content: String, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.EvaluateStudent)?")
        let data = [JSONName.token: token, JSONName.mid: "\(mid)", JSONName.content: content]
        post(url!, action: APIInfo.EvaluateStudent, data: data, responser: responser)
    }
    
    class func setComment(token: String, mid: Int, content: String, shortContent: String, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.HOST)\(APIInfo.SetComment)?")
        let data = [JSONName.token: token, JSONName.mid: "\(mid)", JSONName.content: content, JSONName.shortContent: shortContent]
        post(url!, action: APIInfo.SetComment, data: data, responser: responser)
    }
    /*
    class func downloadImage(path: String, inout image: UIImage, responser: ResponseProtocol) {
        let url = NSURL(string: "\(APIInfo.SERVER)\(path)")
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue();
        let action = APIInfo.DOWNLOADIMAGE
        
        //let connenction: NSURLConnection = NSURLConnection(request: request, delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    responser.didReceiveError(NetworkRequestErrorType.NetworkConnectionError, action: action)
                    })
            } else {
                println(data)
                image = UIImage(data: data)
                if image == nil || image.size == CGSize.zeroSize {
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveError(NetworkRequestErrorType.JSONDataError, action: action)
                        })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveResponse(NSDictionary(), action: action)
                        })
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }*/
    
    class func post(url: NSURL, action: NSString, data: Dictionary<String, String>, responser: ResponseProtocol) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue()
        
        var strData: String = ""
        for (key, value) in data {
            strData += key + "=" + value + "&"
        }
        //strData.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var nsstrData: NSString = NSString(string: strData)
        strData = nsstrData.substringToIndex(nsstrData.length-1)
        nsstrData = NSString(string: strData)
        
        //println(strData)
        
        var postData: NSData = nsstrData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        var postLength: NSString = NSString(format: "%d", nsstrData.length)
        
        
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        
        //println(request.URL)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    responser.didReceiveError(NetworkRequestErrorType.NetworkConnectionError, action: action)
                    })
            } else {
                //println(data)
                var err: NSError? = nil
                NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err)
                
                if (err != nil) {
                    println("json data error")
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveError(NetworkRequestErrorType.JSONDataError, action: action)
                        })

                } else {
                    var jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    //println(jsonData)
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveResponse(jsonData, action: action)
                        })
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }
    
    class func get(url: NSURL, action: NSString, responser: ResponseProtocol) {
        let request: NSURLRequest = NSURLRequest(URL: url)
        let queue: NSOperationQueue = NSOperationQueue();
        
        //let connenction: NSURLConnection = NSURLConnection(request: request, delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { response, data, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    responser.didReceiveError(NetworkRequestErrorType.NetworkConnectionError, action: action)
                    })
            } else {
                //println(data)
                var err: NSError? = nil
                NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err)
                
                if (err != nil) {
                    println("json data error")
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveError(NetworkRequestErrorType.JSONDataError, action: action)
                        })

                } else {
                    var jsonData: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    //println(jsonData)
                    dispatch_async(dispatch_get_main_queue(), {
                        responser.didReceiveResponse(jsonData, action: action)
                        })
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }
    
}