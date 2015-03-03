//
//  ResponseProtocol.swift
//  yohelperteacher
//
//  Created by Park006 on 14-7-17.
//  Copyright (c) 2014年 yozaii. All rights reserved.
//

import Foundation

protocol ResponseProtocol {
    
    func didReceiveResponse()
    func didReceiveResponse(data: NSDictionary, action: NSString)
    func didReceiveError()
    func didReceiveError(error: NetworkRequestErrorType, action: NSString)
}

struct APIInfo {
    static let SERVER = "http://115.29.166.167:8080/"//"http://218.244.141.224:8080"//
    static let HOST = "http://115.29.166.167:8080/yozaii2/api/"//"http://218.244.141.224:8080/yozaii2/api/"//
    static let LOGIN = "auth.action"
    static let GETMYINFO = "getMyInfo.action"
    static let UPDATESTATUS = "setIffree.action"
    static let GetTakeMissions = "getTakeMissions.action"
    static let GetAddMissions = "getAddMissions.action"
    static let GetMissions = "getMissions.action"
    static let GetTeacherEvaluations = "getTeacherEvaluations.action"
    static let EvaluateStudent = "evaluateStudent.action"
    static let GetMyTopics = "getMyTopics.action"
    static let GetTopicTemplate = "getTopicTemplate.action"
    static let SetPassword = "setPassword.action"
    static let SetTwitter = "setTwitter.action"
    static let SetComment = "setComment.action"
    static let SetTopic = "setTopic.action"
    static let AddTopic = "addTopic.action"
    static let ConfirmMission = "confirmMission.action"
    static let DOWNLOADIMAGE = "getImage.action" // not a real api
}

struct JSONName {
    static let errno = "errno"
    static let result = "result"
    static let token = "token"
    static let username = "username"
    static let avatar = "avatar"
    static let phone = "phone"
    static let start = "start"
    static let limit = "limit"
    static let status = "status"
    static let title = "title"
    static let score = "score"
    static let comment = "comment"
    static let createTime = "createTime"
    static let ifEvaluateStudent = "ifEvaluateStudent"
    static let charge = "charge"
    static let lang = "lang"
    static let duration = "duration"
    static let classification = "classification"
    static let content = "content"
    static let del = "del"
    static let id = "id"
    static let uid = "uid"
    static let tid = "tid"
    static let ttid = "ttid"
    static let mid = "mid"
    static let oldPassword = "oldPassword"
    static let newPassword = "newPassword"
    static let twitter = "twitter"
    static let shortContent = "shortcontent"
    static let iffree = "iffree"
    static let numoftopic = "numoftopic"
    static let nickname = "nickname"
}

enum NetworkRequestErrorType {
    case NetworkConnectionError, JSONDataError
}