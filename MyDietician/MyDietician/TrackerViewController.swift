//
//  TrackerViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/7/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ingredients: NSArray? = nil
    
    @IBOutlet weak var total_calories: UILabel!
    @IBOutlet weak var total_protein: UILabel!
    @IBOutlet weak var total_carb: UILabel!
    @IBOutlet weak var total_fats: UILabel!
    
    @IBOutlet weak var AddedItem: UITableView!
    
    var user_dictionary: NSDictionary!
    var user_id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AddedItem.delegate = self
        AddedItem.dataSource = self
        loadtable()
    }

    override func viewWillAppear(animated: Bool) {
        loadtable()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadtable(){
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingIndicator.center = AddedItem.center
        loadingIndicator.startAnimating()
        AddedItem.addSubview(loadingIndicator)
        //        loadingIndicator.showIndicator(parentView: ingredientsTableView)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_dictionary = defaults.objectForKey("current_user") as? NSDictionary
        self.user_dictionary = user_dictionary
        
        getUser({ () -> () in
            print(self.user_id)
            let currentDate = NSDate()
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let timeString = formatter.stringFromDate(currentDate)
            
            // NSLog("(Current Short Time String = \(timeString))")
            
            let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/getNutritionLog.php?user_id=\(self.user_id)&&date=\(timeString)")
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
                                if responseDictionary["results"] is NSNull{
                                    
                                }else{
                                    self.ingredients = responseDictionary["results"] as! NSArray
                                    print(self.ingredients!.count)
                                    //print(self.ingredients![0]["recipe_id"]!!)
                                    loadingIndicator.stopAnimating()
                                    self.AddedItem.reloadData()
                                    print("Removed")
                                }
                        }
                    }
            })
            task.resume()
            
        })

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((ingredients) != nil){
            return (ingredients?.count)!
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = AddedItem.dequeueReusableCellWithIdentifier("IngredientsTableViewCell", forIndexPath: indexPath) as! AddedItemTableViewCell
        cell.item_name!.text = ingredients![indexPath.row]["recipe_id"] as? String
        return cell
    }
    
    func getRecipe(success: ()->()){
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/addRecipe.php?recipe_id=4")
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
                            print("Recipe: ",responseDictionary["results"])
                    }
                }
        })
        task.resume()
    }
    
    func getUser(success: ()->()){
        
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
                            print(responseDictionary["results"]!["user_id"])
                          self.user_id = responseDictionary["results"]!["user_id"] as! String
                            print(self.user_id)
                            success()
                    }
                }
        })
        task.resume()
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
