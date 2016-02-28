//
//  MessageCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 27/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit
import ActiveLabel

class MessageCell: UITableViewCell {

    @IBOutlet weak var txtSender: UILabel!
    @IBOutlet weak var bubble: Bubble!
    @IBOutlet weak var txtBody: ActiveLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(message : Message){
        self.txtBody.text = message.body
        self.txtSender.text = message.belongsToUser ? "Leonardo" : message.sender
        self.txtBody.textAlignment = message.belongsToUser ? .Right : .Left;
        self.txtSender.textAlignment = message.belongsToUser ? .Right : .Left;
        self.txtSender.textColor = Core.colors[message.sender]
        
        self.txtBody.mentionColor = Core.colors[message.sender]!
        self.txtBody.hashtagColor = Core.colors[message.sender]!
        
        setNeedsDisplay()
        layoutSubviews()
    }


    
}
