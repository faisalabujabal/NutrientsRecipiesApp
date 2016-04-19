//
//  SignUpViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 3/31/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var email_address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenter_password: UITextField!
    @IBOutlet weak var status_bar: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        password.secureTextEntry = true
        reenter_password.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create_action(sender: AnyObject) {
 
        if ((first_name.text!) == "") || ((last_name.text!) == "") || ((email_address.text!) == "") || ((password.text!) == ""){
            print("Empty")
            status_bar.text = "*Missing Field"
        }else if isValidEmail(email_address.text!) == false{
            print("Invalid Email Address")
            status_bar.text = "*Invalid Email Address"
            email_address.text = ""
        }else if password.text != reenter_password.text{
            print("Passwords don't match")
            status_bar.text = "*Passwords dont match"
            password.text = ""
            reenter_password.text = ""
        }else{
            status_bar.text = ""
            
            let user_dictionary = [
                "first_name" : first_name.text!,
                "last_name" : last_name.text!,
                "email_address" : email_address.text!,
                "password" : password.text!
            ]
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(user_dictionary, forKey: "current_user")
            defaults.synchronize()
            
            create_account()
        }
    }

    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func create_account(){
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/registerUser.php?firstname=\(first_name.text!)&&lastname=\(last_name.text!)&&email=\(email_address.text!)&&password=\(password.text!)")
        
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
                                let alert = UIAlertController(title: "Error", message: "Email Address already exists!", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                alert.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler: { action in
                                    self.backtohome()
                                }))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                            }else{
                                let alert = UIAlertController(title: "Success", message: "Account Successfully Created", preferredStyle: UIAlertControllerStyle.Alert)
                                
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
                                    self.welcomescreen()
                                }))
                                
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                    }
                }
        })
        task.resume()
    }
    
    func welcomescreen(){
        self.performSegueWithIdentifier("welcome_screen", sender: nil)
    }
    
    func backtohome(){
       navigationController?.popViewControllerAnimated(true)
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
