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
    var isChart : Bool = false
    var labels : [String]?
    var values : [Double]?
    
    var isMap : Bool = false

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
    
    init(labels : [String] , values : [Double]){
        self.labels = labels
        self.values = values
        self.isChart = true
        self.belongsToUser = false
        self.body = ""
        self.sender = ""
    }
    
    init(){
        self.isMap = true
        self.body = ""
        self.sender = ""
        self.belongsToUser = false
    }
}
