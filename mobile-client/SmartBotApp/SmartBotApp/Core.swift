//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation

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

        ]
    ]

    static var currentService = ""
}
