//
//  IngredientsViewController.swift
//  RecipesNutrition
//
//  Created by Faisal Abu Jabal on 3/25/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ingredients: NSArray? = nil
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadingIndicator.center = ingredientsTableView.center
        loadingIndicator.startAnimating()
        ingredientsTableView.addSubview(loadingIndicator)
//        loadingIndicator.showIndicator(parentView: ingredientsTableView)
        
        let ingredientsAPIURL = "http://abujaba2.web.engr.illinois.edu/cs411project/api/ingredients.php"
        
        let requestURL: NSURL = NSURL(string: ingredientsAPIURL)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print(data.dynamicType)
                // we serialize our bytes back to the original JSON structure
                let jsonResult: Dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                let results: NSArray = jsonResult["results"] as! NSArray
                print(results)
                self.ingredients = results
                loadingIndicator.stopAnimating()
                self.ingredientsTableView.reloadData()
                print("Everyone is fine, file downloaded successfully.")
            }
        }
    
        task.resume()
    }

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((ingredients) != nil){
            return (ingredients?.count)!
        } else {
            return 0
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCellWithIdentifier("IngredientsTableViewCell", forIndexPath: indexPath) as! IngredientsTableViewCell
        
        cell.ingredientName.text = ingredients![indexPath.row]["ingredient_name"] as? String
//        let cell = UITableViewCell()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let currCell = sender as? IngredientsTableViewCell
        let currCellIndexPath = ingredientsTableView.indexPathForCell(currCell!)
        let currIngredient = ingredients![currCellIndexPath!.row]
        
        let detailPage = segue.destinationViewController as! IngredientDetailsViewController
        detailPage.details = currIngredient as? NSDictionary
    }

}
