//
//  PromoCodeTableViewCell.swift
//  QRCodeReader
//
//  Created by Paul Colombier on 04/03/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class PromoCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var ui_titleLabel: UILabel!
    @IBOutlet weak var ui_discountLabel: UILabel!
    @IBOutlet weak var ui_endDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
