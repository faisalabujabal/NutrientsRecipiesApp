//
//  EditProfileViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/6/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var email_address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var track: UITextField!
    
    var user_dictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.secureTextEntry=true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_dictionary = defaults.objectForKey("current_user") as? NSDictionary
        self.user_dictionary = user_dictionary
        
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
                                self.first_name.text = responseDictionary["results"]!["user_firstname"] as? String
                                self.last_name.text = responseDictionary["results"]!["user_lastname"] as? String
                                self.email_address.text = responseDictionary["results"]!["user_email"] as? String
                                self.gender.text = responseDictionary["results"]!["user_gender"] as? String
                                self.height.text = responseDictionary["results"]!["user_height"] as? String
                                self.weight.text = responseDictionary["results"]!["user_weight"] as? String
                                self.track.text = responseDictionary["results"]!["user_activity_type"] as? String
                                self.password.text = "Hidden"
                            }
                    }
                }
        })
        task.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save_details(sender: AnyObject) {
        if(checkfields() == true){
            
            update_details()
        }
    }
    
    
    func checkfields()->Bool{
        if ((first_name.text!) == "") || ((last_name.text!) == "") || ((email_address.text!) == "") || ((password.text!) == "") || ((gender.text!) == "") || ((age.text!) == "") || ((weight.text!) == "")  || ((height.text!) == "") || ((track.text!) == ""){
            print("Empty")
            return false
        }
        return true
    }
    
    func update_details(){
        //print(user_dictionary!["email_address"]!)
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/editUser.php?email=\(user_dictionary["email_address"]!)&&weight=\(weight.text!)&&gender=\(gender.text!)&&activity_type=\(track.text!)&&height=\(height.text!)&&new_email=\(email_address.text!)")
        //print(url!)
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
                                let user_dictionary = [
                                    "email_address" : self.email_address.text!,
                                    "password" : self.password.text!
                                ]
                                
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(user_dictionary, forKey: "current_user")
                                defaults.synchronize()
                                
                                self.backtohome()
                            }
                    }
                }
        })
        task.resume()
        
    }
    
    func backtohome(){
         navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            // Get the image captured by the UIImagePickerController
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            
            // Do something with the images (based on your use case)
            profile_image.image = editedImage
            // Dismiss UIImagePickerController to go back to your original view controller
            dismissViewControllerAnimated(true, completion: nil)
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
