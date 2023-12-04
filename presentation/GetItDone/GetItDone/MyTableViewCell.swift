//
//  MyTableViewCell.swift
//  GetItDone
//
//  Created by Saarath Rathee on 2023-11-29.
//

import UIKit

class MyTableViewCell: UITableViewCell {

  
    
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var imageViewbox: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
