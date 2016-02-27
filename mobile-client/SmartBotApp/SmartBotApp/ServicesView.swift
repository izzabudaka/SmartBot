//
// Created by Leonardo Ciocan on 27/02/2016.
// Copyright (c) 2016 LC. All rights reserved.
//

import Foundation
import UIKit

class ServicesView : UIViewController , UITableViewDelegate , UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
