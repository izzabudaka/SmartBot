//
//  ServiceCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 27/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtSubtitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var img2: UIImageView!

    @IBOutlet weak var leftConstant: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()

        img.layer.borderWidth = 1
        img.layer.cornerRadius = img.frame.width/2

        img2.layer.borderWidth = 1
        img2.layer.cornerRadius = img.frame.width/2
        
        img.layer.masksToBounds = true
        img2.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getRandomColor() -> UIColor{

        var randomRed:CGFloat = CGFloat(drand48())

        var randomGreen:CGFloat = CGFloat(drand48())

        var randomBlue:CGFloat = CGFloat(drand48())

        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)

    }
    
    
    
}
