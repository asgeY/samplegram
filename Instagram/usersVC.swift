//
//  usersVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class usersVC: UITableViewController,UISearchBarDelegate{
    
    // declare search bar
    fileprivate var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    fileprivate var usernameArray = [String]()
    fileprivate var avaArray = [PFFile]()
    
    // collectionView UI
    fileprivate var collectionView : UICollectionView!
    
    // collectionView arrays to hold infromation from server
    fileprivate var picArray = [PFFile]()
    fileprivate var uuidArray = [String]()
    fileprivate var page = 15
    
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
        usersQuery.limit = 6
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
        
        //hide follow button for current user
        if cell.username.text == PFUser.current()?.username{
            cell.gradientColor1 = UIColor.white.cgColor
            cell.gradientColor2 = UIColor.white.cgColor
        }else {cell.setImgLayer()}
        
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
        
  self.view.endEditing(true)
        
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

