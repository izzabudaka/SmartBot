//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import SlackTextViewController
import Alamofire

class MessagesView : SLKTextViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    let blackrock_url = "http://3c9be5e7.ngrok.io/command"
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
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("HashCell") {
            cell.textLabel!.text = self.searchResult[indexPath.row]
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        cell.setData(messages[indexPath.row])
        cell.selectionStyle = .None
        return cell
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
        
        
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
