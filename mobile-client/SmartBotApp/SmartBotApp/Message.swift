//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation

class Message {
    var body : String
    var belongsToUser : Bool

    init(body:String,belongsToUser:Bool){
        self.body = body
        self.belongsToUser = belongsToUser
    }
}
