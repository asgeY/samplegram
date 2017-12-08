//
//  feedVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class feedVC: UIViewController,UITableViewDataSource,UIScrollViewDelegate {

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
        
        //set table view cell attributes
setTableCellAttributes()
        
        //add refresher
addRefresher()
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
    
    //set table view cell attributes
    fileprivate func setTableCellAttributes(){
      
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 626
    }
    
    //add refresher
    fileprivate func addRefresher(){
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(feedVC.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    // pagination
   fileprivate func loadMore() {
        
        // if posts on the server are more than shown
        if page <= uuidArray.count {
            
            // start animating indicator
            indicator.startAnimating()
            
            // increase page size to load +10 posts
            page = page + 10
            
   // STEP 1. Find posts realted to people who we are following
let followQuery = PFQuery(className: "follow")
    followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
    followQuery.findObjectsInBackground (block: { (objects, error) in
        if error == nil {
                    
            // clean up
self.followArray.removeAll(keepingCapacity: false)
                    
// find related objects
for object in objects! {
    self.followArray.append(object.object(forKey: "following") as! String)
    }
                    
// append current user to see own posts in feed
self.followArray.append(PFUser.current()!.username!)
                    
// STEP 2. Find posts made by people appended to followArray
    let query = PFQuery(className: "posts")
    query.whereKey("username", containedIn: self.followArray)
query.limit = self.page
query.addDescendingOrder("createdAt")
  query.findObjectsInBackground(block: { (objects, error) in
    if error == nil {
                            
        // clean up
    self.usernameArray.removeAll(keepingCapacity: false)
self.avaArray.removeAll(keepingCapacity: false)
self.dateArray.removeAll(keepingCapacity: false)
    self.picArray.removeAll(keepingCapacity: false)
self.titleArray.removeAll(keepingCapacity: false)
    self.uuidArray.removeAll(keepingCapacity: false)
                            
// find related objects
    for object in objects! {
self.usernameArray.append(object.object(forKey: "username") as! String)
self.avaArray.append(object.object(forKey: "ava") as! PFFile)
self.dateArray.append(object.createdAt)
self.picArray.append(object.object(forKey: "pic") as! PFFile)
self.titleArray.append(object.object(forKey: "title") as! String)
self.uuidArray.append(object.object(forKey: "uuid") as! String)
}
                            
// reload tableView & stop animating indicator
    self.tableView.reloadData()
    self.indicator.stopAnimating()
                            
} else {print(error!.localizedDescription)}})
} else {print(error!.localizedDescription)}
            })
        }
    }
}

//custom functions selector
extension feedVC{
    
     // refreshign function after like to update degit
   @objc fileprivate func refresh() {
        tableView.reloadData()
    }

    // load posts
   @objc fileprivate func loadPosts() {
        
        // STEP 1. Find posts realted to people who we are following
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
        followQuery.findObjectsInBackground (block: { (objects, error) in
            if error == nil {
                
        // clean up
self.followArray.removeAll(keepingCapacity: false)
                
                // find related objects
for object in objects! {
    
self.followArray.append(object.object(forKey: "following") as! String)
}
                
// append current user to see own posts in feed
self.followArray.append(PFUser.current()!.username!)
                
   // STEP 2. Find posts made by people appended to followArray
    let query = PFQuery(className: "posts")
query.whereKey("username", containedIn: self.followArray)
query.limit = self.page
query.addDescendingOrder("createdAt")
query.findObjectsInBackground(block: { (objects, error) in
    if error == nil {
                        
        // clean up
    self.usernameArray.removeAll(keepingCapacity: false)
    self.avaArray.removeAll(keepingCapacity: false)
    self.dateArray.removeAll(keepingCapacity: false)
    self.picArray.removeAll(keepingCapacity: false)
    self.titleArray.removeAll(keepingCapacity: false)
    self.uuidArray.removeAll(keepingCapacity: false)
                        
    // find related objects
for object in objects! {
    
self.usernameArray.append(object.object(forKey: "username") as! String)
self.avaArray.append(object.object(forKey: "ava") as! PFFile)
self.dateArray.append(object.createdAt)
self.picArray.append(object.object(forKey: "pic") as! PFFile)
self.titleArray.append(object.object(forKey: "title") as! String)
self.uuidArray.append(object.object(forKey: "uuid") as! String)
}
                        
    // reload tableView & end spinning of refresher
        self.tableView.reloadData()
        self.refresher.endRefreshing()
} else {print(error!.localizedDescription)}
})
} else {print(error!.localizedDescription)}
        })
    }
}

//UITableViewDataSource
extension feedVC{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        return cell
    }
}

//UIScrollViewDelegate
extension feedVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
}
