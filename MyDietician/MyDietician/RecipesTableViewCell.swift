//
//  RecipesTableViewCell.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/25/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

   
    @IBOutlet weak var recipe_image: UIImageView!
    @IBOutlet weak var recipe_name: UILabel!
    @IBOutlet weak var prep_time: UITextField!
    @IBOutlet weak var cook_time: UITextField!
    @IBOutlet weak var ready_time: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prep_time.userInteractionEnabled = false
        cook_time.userInteractionEnabled = false
        ready_time.userInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
