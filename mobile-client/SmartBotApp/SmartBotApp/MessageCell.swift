//
//  MessageCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 27/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var bubble: Bubble!
    @IBOutlet weak var txtBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setNeedsDisplay()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(message : Message){
        self.txtBody.text = message.body
        self.txtBody.textAlignment = message.belongsToUser ? .Right : .Left;
        setNeedsDisplay()
        layoutSubviews()
    }


    
}
