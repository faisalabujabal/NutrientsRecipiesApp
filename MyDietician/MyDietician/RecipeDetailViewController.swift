//
//  RecipeDetailViewController.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/25/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipe_image: UIImageView!
    @IBOutlet weak var recipe_name: UILabel!
    @IBOutlet weak var prep_time: UITextField!
    @IBOutlet weak var cook_time: UITextField!
    @IBOutlet weak var total_Time: UITextField!
    
    @IBOutlet weak var steps: UILabel!
    var recipe: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prep_time.userInteractionEnabled = false
        cook_time.userInteractionEnabled = false
        total_Time.userInteractionEnabled = false
        
        recipe_name.text = recipe["recipe_name"] as? String
        prep_time.text = recipe["recipe_prep_time"] as? String
        cook_time.text = recipe["recipe_cook_time"] as? String
        total_Time.text = recipe["recipe_ready_in_time"] as? String
        
        if let posterPath = recipe["recipe_image"] as? String {
            let posterBaseUrl = "http://abujaba2.web.engr.illinois.edu/cs411project/"
            let posterUrl = NSURL(string: posterBaseUrl + posterPath)
            recipe_image.setImageWithURL(posterUrl!)
        }
        else {
            recipe_image!.image = nil
        }
        
        steps.text = ""
        for (var i = 1; i<=recipe["directions"]!.count; i++){
            if recipe["directions"]?["\(i)"] != nil{
                //print(recipe["directions"]!["\(i)"]!!)
                steps.text = steps.text! + "\(i). " + (recipe["directions"]!["\(i)"]!! as! String) + "\r\n" + "\r\n"
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
