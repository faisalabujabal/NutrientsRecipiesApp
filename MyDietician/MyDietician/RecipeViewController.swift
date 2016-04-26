//
//  RecipeViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/25/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipe_table: UITableView!
    
    var recipes: NSArray? = nil
    
    var page_count: Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipe_table.dataSource = self
        recipe_table.delegate = self
        // Do any additional setup after loading the view.
        
        
        var boxView = UIView()
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 65, width: 180, height: 50))
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
        
        recipe_table.addSubview(boxView)
        
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/getRecipe.php?limit=\(page_count)")
        
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
                                self.recipes = responseDictionary["results"] as! NSArray
                                //print("Loaded")
                                boxView.removeFromSuperview()
                                self.recipe_table.reloadData()
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
        if((recipes) != nil){
            return (recipes?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipe_table.dequeueReusableCellWithIdentifier("recipe_cell", forIndexPath: indexPath) as! RecipesTableViewCell
        
        cell.recipe_name.text = recipes![indexPath.row]["recipe_name"] as? String
        cell.prep_time.text = recipes![indexPath.row]["recipe_prep_time"] as? String
        cell.cook_time.text = recipes![indexPath.row]["recipe_cook_time"] as? String
        cell.ready_time.text = recipes![indexPath.row]["recipe_ready_in_time"] as? String
        
        if let posterPath = recipes![indexPath.row]["recipe_image"] as? String {
            let posterBaseUrl = "http://abujaba2.web.engr.illinois.edu/cs411project/"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            cell.recipe_image.setImageWithURL(posterUrl!)
        }
        else {
            cell.recipe_image!.image = nil
        }
        
        return cell
    }
    
    func loadMoreData() {
        page_count = page_count+15
        let url = NSURL(string: "http://abujaba2.web.engr.illinois.edu/cs411project/api/getRecipe.php?limit=\(page_count)")
        
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
                                print("No response")
                            }else{
                                self.recipes = responseDictionary["results"] as! NSArray
                                //print("Loaded")
                                self.isMoreDataLoading = false
                                self.recipe_table.reloadData()
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
            
            let scrollViewContentHeight = recipe_table.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - recipe_table.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && recipe_table.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let cell = sender as! RecipesTableViewCell
        let indexPath = recipe_table.indexPathForCell(cell)
        let recipe = recipes![(indexPath?.row)!]
        
        let detailViewController = segue.destinationViewController as! RecipeDetailViewController
        
        detailViewController.recipe = recipe as! NSDictionary
        
    }
    

}
