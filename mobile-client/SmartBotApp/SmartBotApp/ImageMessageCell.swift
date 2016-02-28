//
//  ImageMessageCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 28/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class ImageMessageCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        innerView.layer.cornerRadius = 10
        innerView.layer.masksToBounds = true
    }
    
}
