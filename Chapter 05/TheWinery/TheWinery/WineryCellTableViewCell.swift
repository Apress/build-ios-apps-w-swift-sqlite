//
//  WineryCellTableViewCell.swift
//  TheWinery
//
//  Created by Kevin Languedoc on 2016-07-31.
//  Copyright © 2016 Kevin Languedoc. All rights reserved.
//

import UIKit

class WineryCellTableViewCell: UITableViewCell {

    @IBOutlet weak var wineryNameOutlet: UILabel!
    @IBOutlet weak var regionOutlet: UILabel!
    @IBOutlet weak var countryOutlet: UILabel!
    @IBOutlet weak var volumeOutlet: UILabel!
    @IBOutlet weak var uomOutlet: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
