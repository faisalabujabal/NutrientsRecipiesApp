//
//  AddedItemTableViewCell.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/7/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class AddedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var item_name: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
