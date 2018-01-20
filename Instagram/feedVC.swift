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
    
    fileprivate var refresher = UIRefreshControl()
    
    // arrays to hold server data
   fileprivate var usernameArray = [String]()
   fileprivate var avaArray = [PFFile]()
   fileprivate var dateArray = [Date?]()
   fileprivate var picArray = [PFFile]()
   fileprivate var titleArray = [String]()
   fileprivate var uuidArray = [String]()
    
   fileprivate var followArray = [String]()
    
    // page size
   fileprivate var page = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigation attributes
          setNavAttributes()
        
        //set table view cell attributes
    setTableCellAttributes()
        
        //add refresher
    addRefresher()
        
    // load posts
    loadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //create observers
        createObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//delete observers
deleteObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // clicked username button
    @IBAction func usernameBtn_clicks(_ sender: AnyObject) {
        
    // call index of button
let i = sender.layer.value(forKey: "index") as! IndexPath
        
    // call cell to call further cell data
let cell = tableView.cellForRow(at: i) as! postCell
        
// if user tapped on himself go home, else go guest
    if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
self.navigationController?.show(home, sender: nil)
} else{
guestName.append(cell.usernameBtn.titleLabel!.text!)
let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
self.navigationController?.show(guest, sender: nil)
        }
    }
    
    // clicked comment button
    @IBAction func commentBtn_clicks(_ sender: AnyObject) {
        
 // call index of button
 let i = sender.layer.value(forKey: "index") as! IndexPath
        
// call cell to call further cell data
let cell = tableView.cellForRow(at: i) as! postCell
        
// send related data to global variables
commentuuid.append(cell.uuidLbl.text!)
commentowner.append(cell.usernameBtn.titleLabel!.text!)
}

    
    // clicked more button
    @IBAction func moreBtn_clicks(_ sender: AnyObject) {
        
        // call index of button
let i = sender.layer.value(forKey: "index") as! IndexPath
        
        // call cell to call further cell date
let cell = tableView.cellForRow(at: i) as! postCell
        
        // DELET ACTION
let delete = UIAlertAction(title: "Delete", style: .default) { (UIAlertAction) in
            
    // STEP 1. Delete row from tableView
self.usernameArray.remove(at: i.row)
self.avaArray.remove(at: i.row)
self.dateArray.remove(at: i.row)
self.picArray.remove(at: i.row)
self.titleArray.remove(at: i.row)
self.uuidArray.remove(at: i.row)
            
    // STEP 2. Delete post from server
let postQuery = PFQuery(className: "posts")
postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
postQuery.findObjectsInBackground(block: { (objects, error) in
        if error == nil {
    for object in objects! {
object.deleteInBackground(block: { (success, error)in
if success {
                                
// send notification to rootViewController to update shown posts
NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
                                
    // push back
_ = self.navigationController?.popViewController(animated: true)
} else {print(error!.localizedDescription)}
                        })
                    }
} else {print(error?.localizedDescription ?? String())}})
            
            // STEP 2. Delete likes of post from server
            let likeQuery = PFQuery(className: "likes")
            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            likeQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            // STEP 3. Delete comments of post from server
            let commentQuery = PFQuery(className: "comments")
    commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
commentQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            // STEP 4. Delete hashtags of post from server
            let hashtagQuery = PFQuery(className: "hashtags")
    hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            hashtagQuery.findObjectsInBackground(block: { (objects, error) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
        }
        
        // COMPLAIN ACTION
let complain = UIAlertAction(title: "Complain", style: .default) { (UIAlertAction)  in
            
            // send complain to server
    let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.current()?.username
            complainObj["to"] = cell.uuidLbl.text
complainObj["owner"] = cell.usernameBtn.titleLabel?.text
            complainObj.saveInBackground(block: { (success, error) in
                if success {
self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
                } else {
self.alert("ERROR", message: error!.localizedDescription)
                }
            })
        }
        
        // CANCEL ACTION
let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
    // create menu controller
let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
// if post belongs to user, he can delete post, else he can't
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            menu.addAction(delete)
            menu.addAction(cancel)
        } else {
            menu.addAction(complain)
            menu.addAction(cancel)
        }
        
        // show menu
self.present(menu, animated: true, completion: nil)
}
    
}// feedVC class over line

//custom functions
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
                            
} else {print(error!.localizedDescription)}})
} else {print(error!.localizedDescription)}})
        }
    }
    
    // alert action
fileprivate func alert(_ title: String, message : String) {
let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
present(alert, animated: true, completion: nil)
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
        followQuery.whereKey("follower", equalTo: (PFUser.current()?.username)!)
        followQuery.findObjectsInBackground (block: { (objects, error) in
            if error == nil {
                
        // clean up
self.followArray.removeAll(keepingCapacity: false)
                
                // find related objects
for object in objects! {
    
self.followArray.append(object.object(forKey: "following") as! String)
}
                
// append current user to see own posts in feed
self.followArray.append((PFUser.current()?.username)!)
                
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

//observers
extension feedVC{
    
    //create observers
    fileprivate func createObservers(){
    
        // receive notification from postsCell if picture is liked, to update tableView
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.uploaded(_:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
    }
    
    //delete observers
    fileprivate func deleteObservers(){
        
        NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension feedVC{
  
    // reloading func with posts  after received notification
   @objc fileprivate func uploaded(_ notification:Notification) {
        loadPosts()
    }    
}

//UITableViewDataSource
extension feedVC{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        // connect objects with our information from arrays
cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState())
cell.usernameBtn.sizeToFit()
cell.uuidLbl.text = uuidArray[indexPath.row]
cell.titleLbl.text = titleArray[indexPath.row]
cell.titleLbl.sizeToFit()
        
        // place profile picture
        avaArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.avaImg.image = UIImage(data: data!)
        }
        
        // place post picture
        picArray[indexPath.row].getDataInBackground { (data, error) in
            cell.picImg.image = UIImage(data: data!)
        }
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
// logic what to show: seconds, minuts, hours, days or weeks
        if difference.second! <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second! > 0 && difference.minute! == 0 {
cell.dateLbl.text = "\(difference.second!)s."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
    cell.dateLbl.text = "\(difference.minute!)m."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour!)h."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
        cell.dateLbl.text = "\(difference.day!)d."
        }
        if difference.weekOfMonth! > 0 {
        cell.dateLbl.text = "\(difference.weekOfMonth!)w."
        }
        
// manipulate like button depending on did user like it or not
let didLike = PFQuery(className: "likes")
didLike.whereKey("by", equalTo: PFUser.current()!.username!)
didLike.whereKey("to", equalTo: cell.uuidLbl.text!)
didLike.countObjectsInBackground { (count, error) in
// if no any likes are found, else found likes
if count == 0 {
cell.likeBtn.setTitle("unlike", for: UIControlState())

cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: UIControlState())
            } else {
cell.likeBtn.setTitle("like", for: UIControlState())
cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState())
            }
        }
        
        // count total likes of shown post
let countLikes = PFQuery(className: "likes")
countLikes.whereKey("to", equalTo: cell.uuidLbl.text!)
countLikes.countObjectsInBackground { (count, error) in
            cell.likeLbl.text = "\(count)"
        }
        
// asign index
cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
cell.commentBtn.layer.setValue(indexPath, forKey: "index")
cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        
        // @mention is tapped
cell.titleLbl.userHandleLinkTapHandler = { label, handle, rang in
var mention = handle
mention = String(mention.dropFirst())
            
      // if tapped on @currentUser go home, else go guest
    if mention.lowercased() == PFUser.current()?.username {
let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
                
self.navigationController?.show(home, sender: nil)
            } else {
    guestName.append(mention.lowercased())
                
let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
self.navigationController?.show(guest, sender: nil)
            }
        }
        
        // #hashtag is tapped
cell.titleLbl.hashtagLinkTapHandler = { label, handle, range in
        var mention = handle
        mention = String(mention.dropFirst())
hashtag.append(mention.lowercased())
let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsVC") as! hashtagsVC
            
self.navigationController?.show(hashvc, sender: nil)
        }
        
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
