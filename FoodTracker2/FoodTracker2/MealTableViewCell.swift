//
//  MealTableViewCell.swift
//  FoodTracker2
//
//  Created by Quang Vu on 5/12/17.
//  Copyright © 2017 com.quangvt. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
