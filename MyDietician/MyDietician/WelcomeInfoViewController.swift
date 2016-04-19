//
//  WelcomeInfoViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/6/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class WelcomeInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height_inches: UITextField!
    @IBOutlet weak var activity_type: UITextField!
    
    var user_dictionary: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_dictionary = defaults.objectForKey("current_user") as? NSDictionary
        self.user_dictionary = user_dictionary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func details_save(sender: AnyObject) {
        
        if(checkfields() == true){
            
            update_details()
        }
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
    
    func checkfields()->Bool{
        if ((gender.text!) == "") || ((age.text!) == "") || ((weight.text!) == "")  || ((height_inches.text!) == "") || ((activity_type.text!) == ""){
            print("Empty")
            return false
        }
        return true
    }
    
    func update_details(){
        print(user_dictionary!["email_address"]!)
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/editUser.php?email=\(user_dictionary["email_address"]!)&&weight=\(weight.text!)&&gender=\(gender.text!)&&activity_type=\(activity_type.text!)&&height=\(height_inches.text!))")
        print(url!)
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
                                self.backtohome()
                            }
                    }
                }
        })
        task.resume()

    }

    func backtohome(){
        self.performSegueWithIdentifier("details_saved", sender: nil)
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
