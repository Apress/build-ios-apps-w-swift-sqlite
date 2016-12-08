//
//  WineCellTableViewCell.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-31.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class WineCellTableViewCell: UITableViewCell {

    @IBOutlet weak var wineNameOutlet: UILabel!

    @IBOutlet weak var wineryNameOutlet: UILabel!

    @IBOutlet weak var wineRatingOutlet: UILabel!
    
    @IBOutlet weak var wineImageOutlet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
