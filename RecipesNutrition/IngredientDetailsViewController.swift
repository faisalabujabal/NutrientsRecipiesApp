//
//  IngredientDetailsViewController.swift
//  RecipesNutrition
//
//  Created by Faisal Abu Jabal on 3/25/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class IngredientDetailsViewController: UIViewController {
    
    var details: NSDictionary? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fatAmount: UILabel!
    @IBOutlet weak var carbsAmount: UILabel!
    @IBOutlet weak var sugarAmount: UILabel!
    @IBOutlet weak var protienAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ingredient_protien: "2.58",
//        ingredient_sugar: "2.05",
//        ingredient_carbs: "3.65",
//        ingredient_fat: "0.66",
        if(details != nil){
            fatAmount.text = details!["ingredient_fat"] as? String
            carbsAmount.text = details!["ingredient_carbs"] as? String
            sugarAmount.text = details!["ingredient_sugar"] as? String
            protienAmount.text = details!["ingredient_protien"] as? String
            self.title = details!["ingredient_name"] as? String
            nameLabel.text = details!["ingredient_name"] as? String
        } else {
            fatAmount.text = "0.00"
            carbsAmount.text = "0.00"
            sugarAmount.text = "0.00"
            protienAmount.text = "0.00"
        }
    }

}
