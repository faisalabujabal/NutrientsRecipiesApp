//
//  TwitterClient.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/5/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "oLxjiZBOUQilfzLtT0XiKo5t4", consumerSecret: "zwYhdqB0ykSNVREOXVKtuHfIkIxMyOBeUKoRAzP25ukPI8KOx7")
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    
    func login(success: ()->(), failure: (NSError)->() ){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mydietary://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
            
            
            }) { (error: NSError!) -> Void in
                print("Error in fetching request token: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func handleOpenURL(url: NSURL){
        let request_token = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: request_token, success: { (access_token: BDBOAuth1Credential!) -> Void in
            
            self.loginSuccess?()
            
            }) { (error: NSError!) -> Void in
            self.loginFailure?(error)    
        }
    }
    
    func currentAccount(){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("response: \(response)")
            let user = response as! NSDictionary
            print(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                
        })
    }
    
}
