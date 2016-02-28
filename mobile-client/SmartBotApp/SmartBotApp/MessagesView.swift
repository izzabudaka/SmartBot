//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import SlackTextViewController
import Alamofire
import SwiftyJSON
import Pusher
import PushKit

class MessagesView : SLKTextViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate , PTPusherDelegate{

    let blackrock_url = "http://3c9be5e7.ngrok.io/command"
    let clarifai_url = "https://api.clarifai.com/v1/tag/"
    let imagePicker = UIImagePickerController()
    
    var suggestions : [String] {
        get {
            return Core.hashtags[Core.currentService] ?? []
        }
    }
    
    var suggestionsAt : [String] {
        get {
            return Core.mentions[Core.currentService] ?? []
        }
    }

    var messages : [Message] {
        get {
            return Core.messageStore[Core.currentService]!
        }
        
        set(newVal){
            Core.messageStore[Core.currentService] = newVal
        }
    }
    
    var pipes : [String] {
        get{
            return Array(Core.messageStore.keys)
        }
    }

    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return UITableViewStyle.Plain;
    }
    
    var client : PTPusher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        self.tableView.registerNib(UINib(nibName: "ImageMessageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        //self.tableView.registerClass(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        self.inverted=false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 64.0
//        self.tableView.separatorStyle = .
        self.tableView.tableFooterView = UIView()
        
        
        self.autoCompletionView.dataSource = self
        self.autoCompletionView.delegate = self
        self.registerPrefixesForAutoCompletion(["#","@" ,">"])
        
        self.textView.placeholder = "Write a message"
        self.textView.placeholderColor = UIColor.lightGrayColor()
        
        self.autoCompletionView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HashCell")
        

        self.searchResult = self.suggestions
        
//        
//        self.textInputbar.leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
//        
//        self.leftButton.setTitle("Attach", forState: .Normal)

        self.leftButton.setImage(UIImage(named: "Attach"), forState: UIControlState.Normal)
        self.leftButton.imageView?.contentMode = .ScaleAspectFit
        self.leftButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
        self.leftButton.tintColor = Core.colors[Core.currentService]
        
        
        imagePicker.delegate = self
        
        self.client = PTPusher(key: "061d40c84c49b423dd49" , delegate: self, encrypted: false)
        self.client?.connect()
        
        
        
        
    }
    
    var searchResult : [String] = []

    override func didChangeAutoCompletionPrefix(prefix: String!, andWord word: String!) {
        var array: NSArray = []
        var show = false
        
        if prefix == "#" {
            array = self.suggestions as [AnyObject]
        }
        else if prefix == "@" {
            array = self.suggestionsAt as [AnyObject]
        }
        else if prefix == ">" {
            array = self.pipes as [AnyObject]
        }
        
        if array.count > 0 {
            if word.characters.count > 0 {
                array = array.filteredArrayUsingPredicate(NSPredicate(format: "self BEGINSWITH[c] %@", word))
            }
            
            array = array.sort() { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending }
            
            self.searchResult = array as! [String]
            show = (self.searchResult.count > 0)
        }
        
        self.showAutoCompletionView(show)
    }
    
    override func heightForAutoCompletionView() -> CGFloat {
        return 44 * CGFloat(self.searchResult.count)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        if self.tableView.isEqual(tableView) {
            if(messages[indexPath.row].image != nil){
                let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell") as! ImageMessageCell
                cell.img.image = messages[indexPath.row].image
                cell.selectionStyle = .None
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
                cell.setData(messages[indexPath.row])
                cell.selectionStyle = .None
                return cell
            }
            
        }
        else{
            if let cell = tableView.dequeueReusableCellWithIdentifier("HashCell") {
                cell.textLabel!.text = self.searchResult[indexPath.row]
                
                return cell
            }
        }
        
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableView.isEqual(tableView) {
            return messages.count
        }
        else{
            return self.searchResult.count
        }
    }

    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        self.messages.append(Message(body:self.textView.text,belongsToUser: true,sender: Core.currentService))

        
        
        if Core.currentService == "Blackrock"{
            print("blackrock")
            Alamofire.request(.POST, self.blackrock_url , parameters: ["to": "blackrock" , "message":"get country for ticker GS"] , encoding: .JSON)
                .responseString { response in
                    self.messages.append(Message(body: response.result.value!, belongsToUser: false,sender: Core.currentService))
                    self.tableView.reloadData()
                    print(response.result.value!)
            }
//                .response{
//                    request, response, data, error in
//                    messages.append(Message(body: response.result.value, belongsToUser: false))
            
        }
        else if Core.currentService == "Skyscanner"{
            Alamofire.request(.POST, self.blackrock_url , parameters: ["to": "skyscanner" , "message":self.textView.text] , encoding: .JSON)
                .responseString { response in
                    self.messages.append(Message(body: response.result.value!, belongsToUser: false,sender: Core.currentService))
                    self.tableView.reloadData()
                    print(response.result.value!)
            }
        }
        else if Core.currentService  == "Clarifai"{
            if ((self.messages.last?.body.rangeOfString(">") ) != nil){
                print((self.messages.last?.body)! + "...£")
                let st = self.messages[self.messages.count - 2].body
                let parts = st.componentsSeparatedByString("\n").dropFirst()
                
                                let seconds = 2.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                print(self.messages[self.messages.count - 3].body)
                
                var image : UIImage?
                
                for i in self.messages{
                    if i.image != nil{
                        image = i.image
                    }
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC))),dispatch_get_main_queue() , {
                    self.messages.append(Message(body: "Alright", belongsToUser: false,sender: Core.currentService))
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentSize.height-5), animated: false)

                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        Core.messageStore["Clarifai & Facebook"] = [
                            Message(body: "Hello", belongsToUser: false,sender: Core.currentService),
                            Message(body: "Please post this to your timeline:", belongsToUser: false,sender: Core.currentService),
                            Message(image:image!, belongsToUser: false),
                            Message(body: parts.joinWithSeparator(" "), belongsToUser: false,sender: Core.currentService),
                            Message(body: "Okay , posted!", belongsToUser: false,sender: "Facebook")
                        ]
                        
                        ServicesView.services.append("Clarifai & Facebook")
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                    })
                
                
                
            }
            else{
                print("not found")
            }
        }
        else if Core.currentService == "Macbook"{
                Alamofire.request(.POST, self.blackrock_url , parameters: ["to": "pusher" , "message":self.textView.text] , encoding: .JSON)
                    .responseString { response in
                        self.messages.append(Message(body: response.result.value!, belongsToUser: false,sender: Core.currentService))
                        self.tableView.reloadData()
                        print(response.result.value!)
                }
            
            
        }
        
        self.textView.text = ""
        self.tableView.reloadData()
    }
    
    override func didPressLeftButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        
       
        presentViewController(imagePicker, animated: true, completion: nil)


    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.tableView.isEqual(tableView) {
            var item = self.searchResult[indexPath.row]
            item += " "
            
            self.acceptAutoCompletionWithString(item)
        }
    }


    func showData(){
        self.title = Core.currentService;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.messages.append(Message(image: image, belongsToUser: true))
        self.tableView.reloadData()
        print(Core.currentService)
        if(Core.currentService == "Clarifai"){
        
            self.typingIndicatorView.insertUsername(Core.currentService)
        let parameters : [String:String]
            Alamofire.upload(.POST, clarifai_url,headers:["Authorization":"Bearer 9YPrXNoaU5oS3jZYPrIbO1oDW3pyS5"], multipartFormData: {
                multipartFormData in
                
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: "encoded_image", fileName: "file.png", mimeType: "image/png")
                }
                
                
                //            for (key, value) in parameters {
                //                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                //            }
                
                }
                , encodingCompletion: {
                    encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON{
                            response in
                            
                            let json = JSON(response.result.value!)
                            let answers = json["results"].array![0]["result"]["tag"]["classes"].array![0..<5]
                            
                            var _answers : [String] = []
                            for i in answers{
                                _answers.append(i.stringValue)
                            }
                            
                            
                            
                            self.messages.append(Message(body: "Your image contains : \n#" + _answers.joinWithSeparator("\n#"), belongsToUser: false,sender: Core.currentService))
                            self.tableView.reloadData()
                            
                            self.typingIndicatorView.removeUsername(Core.currentService)
                            
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
            
            
            
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
