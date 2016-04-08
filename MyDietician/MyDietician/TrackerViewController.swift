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
    override func viewDidLoad() {
        super.viewDidLoad()

        AddedItem.delegate = self
        AddedItem.dataSource = self
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingIndicator.center = AddedItem.center
        loadingIndicator.startAnimating()
        AddedItem.addSubview(loadingIndicator)
        //        loadingIndicator.showIndicator(parentView: ingredientsTableView)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_dictionary = defaults.objectForKey("current_user") as? NSDictionary
        self.user_dictionary = user_dictionary
        
        let ingredientsAPIURL = "http://abujaba2.web.engr.illinois.edu/cs411project/api/useraddingredients.php?email=\(user_dictionary!["email_address"]!)"
        
        let requestURL: NSURL = NSURL(string: ingredientsAPIURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {(data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print(data.dynamicType)
                // we serialize our bytes back to the original JSON structure
                let jsonResult: Dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                let results: NSArray = jsonResult["results"] as! NSArray
                self.ingredients = results
                loadingIndicator.stopAnimating()
                self.AddedItem.reloadData()
            }
        }
        
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
        let cell = AddedItem.dequeueReusableCellWithIdentifier("IngredientsTableViewCell", forIndexPath: indexPath) as! AddedItemTableViewCell
        
        cell.item_name!.text = ingredients![indexPath.row]["ingredient_name"] as? String
        return cell
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
