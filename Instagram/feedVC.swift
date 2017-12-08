//
//  feedVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class feedVC: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    {didSet{self.tableView.dataSource = self}}
    
    // UI objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!
     var refresher = UIRefreshControl()
    
    // arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [Date?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    var followArray = [String]()
    
    // page size
    var page = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigation attributes
          setNavAttributes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}// feedVC class over line

extension feedVC{
    
   //set navigation attributes
    fileprivate func setNavAttributes(){
        
        // title at the top
        self.navigationItem.title = "FEED"
    }
    
    fileprivate func setTableCellAttributes(){
      
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 626
    }
    
    //add refresher
    fileprivate func addRefresher(){
        
    }
}

//UITableViewDataSource
extension feedVC{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        return cell
    }
}


