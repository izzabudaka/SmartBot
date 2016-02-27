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


        if(Core.colors[Core.currentService] != nil) {
            UIApplication.sharedApplication().delegate?.window!!.tintColor = Core.colors[Core.currentService]
        }
        
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

    override func viewDidAppear(animated: Bool) {
        UIApplication.sharedApplication().delegate?.window!!.tintColor = UIColor.grayColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Core.currentService = services[indexPath.row]
        performSegueWithIdentifier("toConvo" , sender:self)
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }


    @IBOutlet weak var tableView: UITableView!
    var services : [String] = ["Facebook" , "Amazon" , "Spotify" , "Blackrock & Skyscanner" , "Blackrock"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top:10,left:10,bottom:0,right:0)
//        self.tableView.selectionStyle = .None
        self.tableView.tableFooterView = UIView()
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath) as! ServiceCell
        cell.selectionStyle = .None
        cell.txtTitle.text = services[indexPath.row]
        cell.img2.alpha = services[indexPath.row].rangeOfString("&") != nil ? 1:0;
        if(services[indexPath.row].rangeOfString("&") != nil){
            cell.leftConstant.constant = 10;
            cell.layoutIfNeeded()
        }
        
        if(Core.colors[services[indexPath.row]] != nil) {
//            cell.img.layer.backgroundColor = Core.colors[services[indexPath.row]]?.CGColor
            cell.img.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        if(services[indexPath.row].containsString("&")){
            let first : String = services[indexPath.row].componentsSeparatedByString("&").first!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            let image = UIImage(named: first + ".png")
            if(image != nil){
                cell.img.image = image
            }
            
            
            let second :String = services[indexPath.row].componentsSeparatedByString("&").last!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            let image2 = UIImage(named: second + ".png")
            if(image2 != nil){
                cell.img2.image = image2
            }
            
            
        }
        else{
            let image = UIImage(named: services[indexPath.row] + ".png")
            if(image != nil){
                cell.img.image = image
            }
        }
        
        
        let service : String = self.services[indexPath.row]
        cell.txtSubtitle.text = Core.messageStore[service]?.last?.body
        return cell
    }





}
