//
//  ItemTableViewCell.swift
//  MyDietician
//
//  Created by Shivam Bharuka on 4/8/16.
//  Copyright © 2016 Shivam Bharuka. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var item_name: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var carb: UILabel!
    @IBOutlet weak var fats: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initViews()
    }
    
    func initViews() {
        selectedBackgroundView=UIView(frame: frame)
        selectedBackgroundView!.backgroundColor = UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 0.8)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
