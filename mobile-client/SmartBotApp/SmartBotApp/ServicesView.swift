//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class ServicesView : UIViewController , UITableViewDelegate , UITableViewDataSource {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        (sender.destinationViewController! as! MessagesView).showData();
        
        (segue.destinationViewController).navigationItem.title = Core.currentService

        if(Core.colors[Core.currentService] != nil) {
            UIApplication.sharedApplication().delegate?.window!!.tintColor = Core.colors[Core.currentService]

            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() //Core.colors[Core.currentService]
            self.navigationController?.navigationBar.barTintColor = Core.colors[Core.currentService]
            self.navigationController?.navigationBar.translucent = false
                self.navigationController?.navigationBar.barStyle = .Black

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
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
         self.tableView.reloadData()
        UIApplication.sharedApplication().delegate?.window!!.tintColor = UIColor.grayColor()

        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()//Core.colors[Core.currentService]
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Default

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Core.currentService = ServicesView.services[indexPath.row]
        performSegueWithIdentifier("toConvo" , sender:self)
    }


    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }


    @IBOutlet weak var tableView: UITableView!
    static var services : [String] = ["Facebook" , "Amazon" , "Spotify" , "Blackrock & Skyscanner" , "Blackrock" , "Clarifai","Macbook"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top:15,left:10,bottom:0,right:0)
//        self.tableView.selectionStyle = .None
        self.tableView.tableFooterView = UIView()
        self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.contentSize.height);

    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServicesView.services.count
    }

    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ServiceCell", forIndexPath: indexPath) as! ServiceCell
        cell.selectionStyle = .None
        cell.txtTitle.text = ServicesView.services[indexPath.row]
        cell.img2.alpha = ServicesView.services[indexPath.row].rangeOfString("&") != nil ? 1:0;
        if(ServicesView.services[indexPath.row].rangeOfString("&") != nil){
            cell.leftConstant.constant = 10;
            cell.layoutIfNeeded()
        }
        
        if(Core.colors[ServicesView.services[indexPath.row]] != nil) {
//            cell.img.layer.backgroundColor = Core.colors[services[indexPath.row]]?.CGColor
            //cell.img.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        if(ServicesView.services[indexPath.row].containsString("&")){
            let first : String = ServicesView.services[indexPath.row].componentsSeparatedByString("&").first!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            let image = UIImage(named: first + ".png")
            if(image != nil){
                cell.img.image = image
            }
            
            
            let second :String = ServicesView.services[indexPath.row].componentsSeparatedByString("&").last!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            let image2 = UIImage(named: second + ".png")
            if(image2 != nil){
                cell.img2.image = image2
            }
            
            
        }
        else{
            let image = UIImage(named: ServicesView.services[indexPath.row] + ".png")
            if(image != nil){
                cell.img.image = image
            }
        }
        
        
        let service : String = ServicesView.services[indexPath.row]
        cell.txtSubtitle.text = Core.messageStore[service]?.last?.body
        return cell
    }





}
