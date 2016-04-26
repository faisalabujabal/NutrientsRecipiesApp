//
//  ItemlistViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/8/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ItemlistViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ItemtableView: UITableView!
    
    var ingredients: NSArray? = nil
    
    var user_dictionary: NSDictionary!
    var user_id: String!
    
    var page_count: Int = 15
    var checked: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ItemtableView.dataSource = self
        ItemtableView.delegate = self
       // ItemtableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "item_detail")
        
        self.ItemtableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        var boxView = UIView()
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
        boxView.backgroundColor = UIColor.grayColor()
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        let textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.whiteColor()
        textLabel.text = "Loading"
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        ItemtableView.addSubview(boxView)
        
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/ingredients.php?limit=\(page_count)")
  
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
                                if((self.ingredients) != nil){
                                    self.checked = [Bool](count: (self.ingredients?.count)!, repeatedValue: false)
                                }
                                //print("Loaded")
                                boxView.removeFromSuperview()
                                self.ItemtableView.reloadData()
                                //print("Removed")
                            }
                    }
                }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((ingredients) != nil){
            return (ingredients?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ItemtableView.dequeueReusableCellWithIdentifier("item_detail", forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.item_name!.text = ingredients![indexPath.row]["ingredient_name"] as? String
        cell.protein!.text = ingredients![indexPath.row]["ingredient_protien"] as? String
        cell.carb!.text = ingredients![indexPath.row]["ingredient_carbs"] as? String
        cell.fats!.text = ingredients![indexPath.row]["ingredient_fat"] as? String
        
        if checked[indexPath.row] {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func loadMoreData() {
        page_count = page_count + 15
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/ingredients.php?limit=\(page_count)")
        
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
                                if((self.ingredients) != nil){
                                    self.checked = [Bool](count: (self.ingredients?.count)!, repeatedValue: false)
                                }
                                //print("Loaded")
                                self.isMoreDataLoading = false
                                self.ItemtableView.reloadData()
                                //print("Removed")
                            }
                    }
                }
        })
        task.resume()
    }
    
    var isMoreDataLoading = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
           
            let scrollViewContentHeight = ItemtableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - ItemtableView.bounds.size.height
          
            if(scrollView.contentOffset.y > scrollOffsetThreshold && ItemtableView.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        ItemtableView.deselectRowAtIndexPath(indexPath, animated: true)
        checked[indexPath.row] = !checked[indexPath.row]
        ItemtableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
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
            
            let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/addNutritionLog.php?user_id=\(self.user_id)&&date=\(timeString)&&recipe_id=\(self.ingredients![indexPath.row]["ingredient_id"]!!)")
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
                                    print(responseDictionary)
                                    let alert = UIAlertController(title: "Success", message: "Successfully Added", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: { action in
                                        self.backtohome()
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "Add More", style: UIAlertActionStyle.Default, handler: { action in
                                   
                                    }))
                                    
                                    self.presentViewController(alert, animated: true, completion: nil)
                                }
                        }
                    }
            })
            task.resume()
            
        })

    }
    
    func backtohome(){
        navigationController?.popViewControllerAnimated(true)
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
