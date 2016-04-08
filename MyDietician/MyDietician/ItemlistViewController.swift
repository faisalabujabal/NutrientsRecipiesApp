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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ItemtableView.dataSource = self
        ItemtableView.delegate = self
       
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingIndicator.center = ItemtableView.center
        loadingIndicator.startAnimating()
        ItemtableView.addSubview(loadingIndicator)
        //        loadingIndicator.showIndicator(parentView: ingredientsTableView)
        
        let ingredientsAPIURL = "http://abujaba2.web.engr.illinois.edu/cs411project/api/ingredients.php"
        
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
                self.ItemtableView.reloadData()
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
        let cell = ItemtableView.dequeueReusableCellWithIdentifier("item_detail", forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.item_name!.text = ingredients![indexPath.row]["ingredient_name"] as? String
        cell.protein!.text = ingredients![indexPath.row]["ingredient_protien"] as? String
        cell.carb!.text = ingredients![indexPath.row]["ingredient_carbs"] as? String
        cell.fats!.text = ingredients![indexPath.row]["ingredient_fat"] as? String
        cell.servings!.text = ingredients![indexPath.row]["ingredient_serving_size"] as? String
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
