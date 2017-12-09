//
//  usersVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class usersVC: UITableViewController,UISearchBarDelegate {

    // declare search bar
var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    var usernameArray = [String]()
var avaArray = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}//usersVC class over line

extension usersVC{
    
    fileprivate func setSearchBarAttributes(){
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
    }
}

