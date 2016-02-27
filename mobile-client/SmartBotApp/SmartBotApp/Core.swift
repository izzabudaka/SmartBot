//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Core {
    static var messageStore : [String : [Message]] = [
        "Blackrock" : [],
        "Facebook" : [
            Message(body: "Obama tagged you in a picture", belongsToUser: true),
            Message(body: "Post this post", belongsToUser: true),
            Message(body: "Done!", belongsToUser: false)
        ],
        "Spotify" : [
            Message(body: "Barack added a new track to your playlist", belongsToUser: false)
        ],
        "Amazon" : [
            Message(body: "The item \"50 gallons of jelly\" on your wishlist has gone down in price by £20.Buy now?", belongsToUser: false)
        ],
        "Skyscanner":[]
    ]

    static var currentService : String = ""
    
    static var colors : [String : UIColor] = [
        "Facebook" : UIColor(hue: 0.5778, saturation: 1, brightness: 0.99, alpha: 1.0) ,
        "Blackrock" : UIColor.blackColor(),
        "Amazon" : UIColor.orangeColor(),
        "Spotify" : UIColor.greenColor(),
        "Skyscanner" : UIColor.blueColor()
    ]
}
