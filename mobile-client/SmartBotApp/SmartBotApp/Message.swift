//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var body : String
    var belongsToUser : Bool
    var sender : String
    var image : UIImage?

    init(body:String,belongsToUser:Bool , sender : String){
        self.body = body
        self.belongsToUser = belongsToUser
        self.sender = sender
    }
    
    init(image: UIImage , belongsToUser:Bool){
        self.image = image
        self.belongsToUser = belongsToUser
        self.body = ""
        self.sender = ""
    }
}
