//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import SlackTextViewController
import Alamofire
import SwiftyJSON
class MessagesView : SLKTextViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

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

    override class func tableViewStyleForCoder(decoder: NSCoder) -> UITableViewStyle {
        return UITableViewStyle.Plain;
    }

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
        self.registerPrefixesForAutoCompletion(["#","@"])
        
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
    }
    
    var searchResult : [String] = []

    override func didChangeAutoCompletionPrefix(prefix: String!, andWord word: String!) {
        print(self.searchResult)
        var array: NSArray = []
        var show = false
        
        if prefix == "#" {
            array = self.suggestions as [AnyObject]
        }
        else if prefix == "@" {
            array = self.suggestionsAt as [AnyObject]
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
        print(String(section) + " >>> ")
        if self.tableView.isEqual(tableView) {
            return messages.count
        }
        else{
            return self.searchResult.count
        }
    }

    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        self.messages.append(Message(body:self.textView.text,belongsToUser: true))
        self.textView.text = ""
        self.tableView.reloadData()
        self.tableView.reloadData()
        
        
        if Core.currentService == "Blackrock"{
            print("blackrock")
            Alamofire.request(.POST, self.blackrock_url , parameters: ["to": "blackrock" , "message":"get country for ticker GS"] , encoding: .JSON)
                .responseString { response in
                    self.messages.append(Message(body: response.result.value!, belongsToUser: false))
                    self.tableView.reloadData()
                    print(response.result.value!)
            }
//                .response{
//                    request, response, data, error in
//                    messages.append(Message(body: response.result.value, belongsToUser: false))
            
        }
    }
    
    override func didPressLeftButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        
       
        presentViewController(imagePicker, animated: true, completion: nil)


    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(tableView) {
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
        
        if(Core.currentService == "Clarifai"){
        
//        let parameters : [String:String]
//            Alamofire.upload(.POST, clarifai_url,headers:["Authorization":"Bearer 9YPrXNoaU5oS3jZYPrIbO1oDW3pyS5"], multipartFormData: {
//                multipartFormData in
//                
//                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
//                    multipartFormData.appendBodyPart(data: imageData, name: "encoded_image", fileName: "file.png", mimeType: "image/png")
//                }
//                
//                
//                //            for (key, value) in parameters {
//                //                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
//                //            }
//                
//                }
//                , encodingCompletion: {
//                    encodingResult in
//                    
//                    switch encodingResult {
//                    case .Success(let upload, _, _):
//                        upload.responseJSON{
//                            response in
//                            
//                            let json = JSON(response.result.value!)
//                            let answers = json["results"].array![0]["result"]["tag"]["classes"].array![0..<5]
//                            
//                            var _answers : [String] = []
//                            for i in answers{
//                                _answers.append(i.stringValue)
//                            }
//                            
//                            
//                            
//                            self.messages.append(Message(body: "Just a sec", belongsToUser: false))
//                            self.messages.append(Message(body: "Your image contains : \n#" + _answers.joinWithSeparator("\n#"), belongsToUser: false))
//                            self.tableView.reloadData()
//                            
//                        }
//                    case .Failure(let encodingError):
//                        print(encodingError)
//                    }
//            })
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
