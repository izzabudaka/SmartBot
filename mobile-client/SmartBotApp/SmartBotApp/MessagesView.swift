//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import SlackTextViewController
import Alamofire

class MessagesView : SLKTextViewController  {

    let blackrock_url = "http://3c9be5e7.ngrok.io/command"

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
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        cell.setData(messages[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func didPressRightButton(sender: AnyObject!) {
        self.textView.refreshFirstResponder()
        self.messages.append(Message(body:self.textView.text,belongsToUser: true))
        self.textView.text = ""
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


    func showData(){
        self.title = Core.currentService;
    }
}
