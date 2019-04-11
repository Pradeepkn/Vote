//
//  NXTVoteConfigurationHelper.swift
//  Vote
//
//  Created by Pradeep on 4/10/19.
//  Copyright © 2019 Tarento Technologies Pvt Ltd. All rights reserved.
//

import UIKit

struct Status : Decodable {
    var statusMessage : String
    var statusCode : Int
    var errorMessage : String
}

struct CustomError: Error, Decodable {
    var message: String
}

struct VotingProjectsResponse : Decodable {
    var statusInfo : Status?
    var responseData : ProjectList?
}

struct ProjectList : Decodable {
    var projects : [ProjectDetails]?
}

struct ProjectDetails : Decodable {
    var id : Int64?
    var name : String?
    var logo : String?
    var description : String?
}


class NXTVoteConfigurationHelper: NSObject {

    typealias ResponseHandler = (VotingProjectsResponse?) -> Void

    public static let sharedWebClient = WebClient.init(baseUrl: "http://www.mocky.io/v2/")

    static func getProjectLists(completionHandler:@escaping NXTVoteConfigurationHelper.ResponseHandler) {
        var configurationTask : URLSessionDataTask!
        configurationTask?.cancel()
        let requestPath = "5caeefc8340000972fab6eea"
        
        let configurationResource = Resource<VotingProjectsResponse, CustomError>(jsonDecoder: JSONDecoder(), path: requestPath)
        
        configurationTask = NXTVoteConfigurationHelper.sharedWebClient.load(resource: configurationResource) { response in
            DispatchQueue.main.async {
                if let statusInfo = response.value?.statusInfo {
                    if statusInfo.statusCode == 200 {
                        completionHandler(response.value)
                    }else {
                        completionHandler(nil)
                    }
                } else if let error = response.error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            }
        }
    }
    
}
