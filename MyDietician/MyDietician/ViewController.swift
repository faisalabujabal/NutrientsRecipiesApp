//
//  ViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 3/28/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    @IBOutlet weak var email_id: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      password.secureTextEntry=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sign_in(sender: AnyObject) {
        
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/loginUser.php?email=\(email_id.text!)&&password=\(password.text!)")
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            if responseDictionary["results"] is NSNull || self.email_id.text == "" || self.password.text == "" {
                                let alert = UIAlertController(title: "Error", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }else{
                                let user_dictionary = [
                                    "email_address" : self.email_id.text!,
                                    "password" : self.password.text!
                                ]
                                
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(user_dictionary, forKey: "current_user")
                                defaults.synchronize()
                                
                                self.performSegueWithIdentifier("logged_in", sender: nil)
                            }
                    }
                }
        })
        task.resume()
    }
    
    @IBAction func onLoginWithTwitter(sender: AnyObject) {
        TwitterClient.sharedInstance.login({ () -> () in
           self.performSegueWithIdentifier("welcome_twitter", sender: nil)
            }) { (error: NSError) -> () in
                
        }
    }

}

