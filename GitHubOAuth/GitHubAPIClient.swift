//
//  GitHubAPIClient.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/31/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class GitHubAPIClient {
   
   // MARK: Path Router
   enum URLRouter {
      static let repo = "https://api.github.com/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
      static let token = "https://github.com/login/oauth/access_token"
      static let oauth = "https://github.com/login/oauth/authorize?client_id=\(Secrets.clientID)&scope=repo"
      
      static func starred(repoName repo: String) -> String? {
         
         let starredURL = "https://api.github.com/user/starred/\(repo)?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)&access_token="
         
         // TO DO: Add access token to starredURL string and return
         return nil
      }
   }
   
}

// MARK: Repositories
extension GitHubAPIClient {
   
   class func getRepositoriesWithCompletion(completionHandler: (JSON?) -> Void) {
      
      Alamofire.request(.GET, URLRouter.repo)
         .validate()
         .responseJSON(completionHandler: { response in
            switch response.result {
            case .Success:
               if let data = response.data {
                  completionHandler(JSON(data: data))
               }
            case .Failure(let error):
               print("ERROR: \(error.localizedDescription)")
               completionHandler(nil)
            }
         })
      
   }
   
}


// MARK: OAuth
extension GitHubAPIClient {
   
   
   class func hasToken() -> Bool {
      
      return false
   }
   
   // Start access token request process
   class func startAccessTokenRequest(url url: NSURL, completionHandler: (Bool) -> ()) {
      let oAuthCode = url.getQueryItemValue(named: "code")
      guard let temporyCode = oAuthCode where oAuthCode != nil else {
         completionHandler(false)
         return
      }
      
      let gitHubParameters = ["client_id": Secrets.clientID, "client_secret": Secrets.clientSecret, "code": temporyCode]
      let gitHubHeader = ["Accept": "application/json"]
      Alamofire.request(.POST, URLRouter.token, parameters: gitHubParameters, headers: gitHubHeader).responseJSON { response in
         if response.result.isSuccess {
            print(response)
            completionHandler(true)
         } else {
            completionHandler(false)
         }
      }
   }
   
   // Save access token from request response to keychain
   private class func saveAccess(token token: String, completionHandler: (Bool) -> ()) {
      
   }
   
   // Get access token from keychain
   private class func getAccessToken() -> String? {
      
      return nil
      
   }
   
   // Delete access token from keychain
   class func deleteAccessToken(completionHandler: (Bool) -> ()) {
      
   }
}


// MARK: Activity
extension GitHubAPIClient {
   
   class func checkIfRepositoryIsStarred(fullName: String, completionHandler: (Bool?) -> ()) {
      
      guard let urlString = URLRouter.starred(repoName: fullName) else {
         print("ERROR: Unable to get url path for starred status")
         completionHandler(nil)
         return
      }
      
      Alamofire.request(.GET, urlString)
         .validate(statusCode: 204...404)
         .responseString(completionHandler: { response in
            switch response.result {
            case .Success:
               if response.response?.statusCode == 204 {
                  completionHandler(true)
               } else if response.response?.statusCode == 404 {
                  completionHandler(false)
               }
            case .Failure(let error):
               print("ERROR: \(error.localizedDescription)")
               completionHandler(nil)
            }
            
            
         })
      
   }
   
   class func starRepository(fullName: String, completionHandler: (Bool) -> ()) {
      
      guard let urlString = URLRouter.starred(repoName: fullName) else {
         print("ERROR: Unable to get url path for starred status")
         completionHandler(false)
         return
      }
      
      Alamofire.request(.PUT, urlString)
         .validate(statusCode: 204...204)
         .responseString(completionHandler: { response in
            switch response.result {
            case .Success:
               completionHandler(true)
            case .Failure(let error):
               print("ERROR: \(error.localizedDescription)")
               completionHandler(false)
            }
         })
      
   }
   
   class func unStarRepository(fullName: String, completionHandler: (Bool) -> ()) {
      
      guard let urlString = URLRouter.starred(repoName: fullName) else {
         print("ERROR: Unable to get url path for starred status")
         completionHandler(false)
         return
      }
      
      Alamofire.request(.DELETE, urlString)
         .validate(statusCode: 204...204)
         .responseString(completionHandler: { response in
            switch response.result {
            case .Success:
               completionHandler(true)
            case .Failure(let error):
               print("ERROR: \(error.localizedDescription)")
               completionHandler(false)
            }
         })
      
   }
   
}

