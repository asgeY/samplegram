//
//  optionsVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 1/3/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Parse

class optionsVC: UITableViewController {

    @IBOutlet weak var logOutCell: UITableViewCell!
  
    @IBOutlet weak var facebookImageView: UIImageView!
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configue navigation bar
        configNavigationBar()
     
      //set log out cell title
        setLogOutCellTitle()

     //set image view insets
        setImageViewInsets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   
    }

   
}//optionsVC class over line

//custom functions
extension optionsVC{
    
    fileprivate func setImageViewInsets(){
        facebookImageView.image = #imageLiteral(resourceName: "facebook").imageWithInset(insets: UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7))
        contactImageView.image = #imageLiteral(resourceName: "contacts").imageWithInset(insets: UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7))
    }
    
    fileprivate func configNavigationBar(){
        self.navigationItem.title = "Options"
self.navigationController?.navigationBar.tintColor = .white
    }
    
    fileprivate func setLogOutCellTitle(){
    logOutCell.textLabel?.text = "Log Out Of \((PFUser.current()?.username)!)"
    }
}

//UITableViewDelegate
extension optionsVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4,indexPath.row == 2
        {
    PFUser.logOutInBackground { (error) in
                
    if error == nil {
                    
let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! signInVC
                    
    // remove logged in user from App memory
UserDefaults.standard.removeObject(forKey: "username")
UserDefaults.standard.synchronize()
                    
let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = signIn
                }
            }
        }
    tableView.deselectRow(at: indexPath, animated: true)
    }
}
