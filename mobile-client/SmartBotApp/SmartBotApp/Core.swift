//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class Core {
    static var messageStore : [String : [Message]] = [
        "Blackrock" : [
            Message(labels:["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], values:[20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0])
        ],
        "Facebook" : [
            Message(body: "Obama tagged you in a picture", belongsToUser: false,sender: "Facebook"),
            Message(body: "Like that", belongsToUser: true,sender: "Facebook"),
            Message(body: "Done! 👍", belongsToUser: false,sender: "Facebook")
        ],
        "Spotify" : [
            Message(body: "Barack added a new track to your playlist", belongsToUser: false,sender: "Spotify")
        ],
        "Amazon" : [
            Message(body: "The item \"50 gallons of jelly\" on your wishlist has gone down in price by £20.Buy now?", belongsToUser: false,sender: "Amazon")
        ],
        "Skyscanner":[
        ],
        "Clarifai" : [
            Message(body: "Here they are\n#cake\npineapple\npie", belongsToUser: false,sender: "Clarifai")
        ],
        "Macbook" : [
            Message(body: "Someone tried to acces your protected folder /home/Videos/MathsVideos/Olympics/PDF/2009/PleaseDontReadThis", belongsToUser: false, sender: "Macbook"),
            Message(body: "Restart needed for updates. Postpone this?", belongsToUser: false, sender: "Macbook"),
            Message(body: "Yes", belongsToUser: true, sender: "Macbook"),
            Message(body: "I'm afriad I can't do that , Leonardo", belongsToUser: false, sender: "Macbook")
        ],
        "Blackrock & Skyscanner" :[]
    ]

    static var currentService : String = ""
    
    static var colors : [String : UIColor] = [
        "Facebook" : UIColor(red:0.231 , green:0.349 , blue:0.596  , alpha:1),
        "Blackrock" : UIColor.blackColor(),
        "Amazon" : UIColor.orangeColor(),
        "Spotify" : UIColor.greenColor(),
        "Skyscanner" : UIColor(hue: 0.55, saturation: 1, brightness: 0.98, alpha: 1.0),
        "Clarifai" : UIColor(hue: 0.5917, saturation: 1, brightness: 0.9, alpha: 1.0),
        "Macbook" : UIColor.grayColor()
    ]
    
    
    static var hashtags : [ String : [String]] = [
        "Blackrock" : ["AAPL" , "GOOG" , "MSFT" , "BLK","GS"],
        "Facebook" : ["timeline" , "hacklondon2016" , "notes"],
        "Amazon" : ["christmas" , "basket" , "techstuff" ],
        "Skyscanner" : ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada"],
        "Macbook" : ["projectImagesFolder" , "imagesFolder" ,"catPicturesRepo"]
    ]

    
    static var mentions : [String : [String]] = [
        "Facebook" : ["Bill Gates" , "Jesus M. Christ" , "Rick Astley"],
        "Macbook" : ["iTunes" , "System" , "Automator"]
    ]
    
    
    
}
