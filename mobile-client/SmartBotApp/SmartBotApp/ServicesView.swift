//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class ServicesView : UIViewController , UITableViewDelegate , UITableViewDataSource {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        (sender.destinationViewController! as! MessagesView).showData();
        
        (segue.destinationViewController).navigationController?.title = Core.currentService
        print(Core.messageStore)
//
//        if let store = Core.messageStore[Core.currentService]{
//            (segue.destinationViewController as! MessagesView).messages = Core.messageStore[Core.currentService]!
//        }
//        else{
//            print(Core.currentService + " not working");
//        }
        super.prepareForSegue(segue, sender: sender)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Core.currentService = services[indexPath.row]
        performSegueWithIdentifier("toConvo" , sender:self)
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }


    @IBOutlet weak var tableView: UITableView!
    var services : [String] = ["Facebook" , "Amazon" , "Spotify" , "Blackrock & Skyscaner" , "Blackrock"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top:10,left:0,bottom:0,right:0)
//        self.tableView.selectionStyle = .None
        self.tableView.tableFooterView = UIView()
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath) as! ServiceCell
        cell.txtTitle.text = services[indexPath.row]
         cell.img2.alpha = services[indexPath.row].rangeOfString("&") != nil ? 1:0;
        return cell
    }





}
