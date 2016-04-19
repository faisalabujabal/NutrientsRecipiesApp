//
//  ProfileViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/6/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var track: UILabel!
    
    @IBOutlet var mainView: UIView!
    var user_dictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apicall()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        apicall()
    }

    func apicall(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_dictionary = defaults.objectForKey("current_user") as? NSDictionary
        self.user_dictionary = user_dictionary
        
        print(user_dictionary!["email_address"]!)
        
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/getUser.php?email=\(user_dictionary!["email_address"]!)")
        
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
                            print("response: \(responseDictionary)")
                            
                            if responseDictionary["results"] is NSNull{
                                
                            }else{
                                self.full_name.text = (responseDictionary["results"]!["user_firstname"] as? String)! + (responseDictionary["results"]!["user_lastname"] as? String)!
                                self.gender.text = responseDictionary["results"]!["user_gender"] as? String
                                self.height.text = responseDictionary["results"]!["user_height"] as? String
                                self.weight.text = responseDictionary["results"]!["user_weight"] as? String
                                self.track.text = responseDictionary["results"]!["user_activity_type"] as? String
                            }
                    }
                }
        })
        task.resume()
    }
    @IBAction func logout_user(sender: AnyObject) {
         let defaults = NSUserDefaults.standardUserDefaults()
         defaults.removeObjectForKey("current_user")
        mainView.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("userloggedout", object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
