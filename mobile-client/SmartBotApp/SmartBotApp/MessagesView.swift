//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import SlackTextViewController

class MessagesView : SLKTextViewController  {

    let url = "http://3c9be5e7.ngrok.io/command"

    var messages : [Message] = [
            Message(body: "Hello world" , belongsToUser: true),
            Message(body: "Second message" , belongsToUser: true),
            Message(body: "Reply from service" , belongsToUser: false),
            Message(body: "Final reply" , belongsToUser: true)
    ]

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
        messages.append(Message(body:self.textView.text,belongsToUser: true))
        self.textView.text = ""
        self.tableView.reloadData()
    }

}
