//
//  MessageCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 27/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var txtSender: UILabel!
    @IBOutlet weak var bubble: Bubble!
    @IBOutlet weak var txtBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(message : Message){
        self.txtBody.text = message.body
        self.txtSender.text = message.belongsToUser ? "" : message.sender
        self.txtBody.textAlignment = message.belongsToUser ? .Right : .Left;
        self.txtSender.textAlignment = message.belongsToUser ? .Right : .Left;
        self.txtSender.textColor = Core.colors[message.sender]
        
        setNeedsDisplay()
        layoutSubviews()
    }


    
}
