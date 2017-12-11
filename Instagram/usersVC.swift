//
//  usersVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class usersVC: UITableViewController,UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    // declare search bar
var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    var usernameArray = [String]()
var avaArray = [PFFile]()
  
    // collectionView UI
    var collectionView : UICollectionView!
    
    // collectionView arrays to hold infromation from server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var page = 15

    override func viewDidLoad() {
        super.viewDidLoad()

       //set search bar attributes
        setSearchBarAttributes()
       
        //fetch user info from server
        loadUsers()
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
    
    // load users function
   fileprivate func loadUsers() {
        
        let usersQuery = PFQuery(className: "_User")
        usersQuery.addDescendingOrder("createdAt")
        usersQuery.limit = 20
        usersQuery.findObjectsInBackground (block: { (objects, error) in
            if error == nil {
                
                // clean up
self.usernameArray.removeAll(keepingCapacity: false)
self.avaArray.removeAll(keepingCapacity: false)
                
    // found related objects
   for object in objects! {
    
self.usernameArray.append(object.value(forKey: "username") as! String)
self.avaArray.append(object.value(forKey: "ava") as! PFFile)
}
                
        // reload
           self.tableView.reloadData()
} else {print(error!.localizedDescription)}
        })
    }
    
// COLLECTION VIEW CODE
    fileprivate func collectionViewLaunch(){
        
        // layout of collectionView
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // item size
        layout.itemSize = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        
        // direction of scrolling
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // define frame of collectionView
let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        
        // declare collectionView
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        // define cell for collectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

//UITableViewDataSource
extension usersVC{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! followersCell
        
        cell.followBtn.isHidden = true
        
        // connect cell's objects with received infromation from server
        cell.username.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
}

//UITableViewDelegate
extension usersVC{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // calling cell again to call cell data
        let cell = tableView.cellForRow(at: indexPath) as! followersCell
        
        // if user tapped on his name go home, else go guest
        if cell.username.text! == PFUser.current()?.username {
let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
self.navigationController?.show(home, sender: nil)
        } else {guestName.append(cell.username.text!)
        let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
self.navigationController?.show(guest, sender: nil)
        }
    }
}

//UISearchBarDelegate
extension usersVC{
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
// find by username
let usernameQuery = PFQuery(className: "_User")
usernameQuery.whereKey("username", matchesRegex: "(?i)" + searchBar.text!)
usernameQuery.findObjectsInBackground (block: { (objects, error) in
            if error == nil {
                
       // if no objects are found according to entered text in usernaem colomn, find by fullname
    if objects!.isEmpty {
                    
let fullnameQuery = PFUser.query()
fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
fullnameQuery?.findObjectsInBackground(block: { (objects, error) in
        if error == nil {
                            
            // clean up
self.usernameArray.removeAll(keepingCapacity: false)
self.avaArray.removeAll(keepingCapacity: false)
                            
    // found related objects
    for object in objects! {
self.usernameArray.append(object.object(forKey: "username") as! String)
self.avaArray.append(object.object(forKey: "ava") as! PFFile)
    }
                            
     // reload
        self.tableView.reloadData()
        }
    })
}

// clean up
self.usernameArray.removeAll(keepingCapacity: false)
self.avaArray.removeAll(keepingCapacity: false)
                
                // found related objects
        for object in objects! {
    self.usernameArray.append(object.object(forKey: "username") as! String)
    self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                }
                
                // reload
                self.tableView.reloadData()
            }
        })
        
        return true
    }
    
    // clicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUsers()
    }
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
}

//UICollectionViewDataSource
extension usersVC{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // create picture imageView in cell to show loaded pictures
        let picImg = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        cell.addSubview(picImg)
        
        // get loaded images from array
        picArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
}

//UICollectionViewDelegate
extension usersVC{
    
    // cell line spasing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell inter spasing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell's selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // take relevant unique id of post to load post in postVC
        postuuid.append(uuidArray[indexPath.row])
        
        // present postVC programmaticaly
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
}
