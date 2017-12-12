//
//  tabbarVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

// global variables of icons
var icons = UIScrollView()
var corner = UIImageView()
var dot = UIView()

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tab bar layer
setTabBarLayer()
        
        // creare total icons
createIcons()
        
        // create corner
createCornerIcon()
        
        // create dot
createDotIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}// tabbarVC class over line

//custom functions
extension tabbarVC{
    
    //set tab bar layer
    fileprivate func setTabBarLayer(){
        
        // color of background
        self.tabBar.barTintColor = .white
        
        // disable translucent
        self.tabBar.isTranslucent = false
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
    }
    
    // creare total icons
    fileprivate func createIcons(){
        
        // create total icons
        icons.frame = CGRect(x: self.view.frame.size.width / 5 * 3 + 10, y: self.view.frame.size.height - self.tabBar.frame.size.height * 2 - 3, width: 50, height: 35)
        self.view.addSubview(icons)
    }
    
    // create corner
    fileprivate func createCornerIcon(){
        
        corner.frame = CGRect(x: icons.frame.origin.x, y: icons.frame.origin.y + icons.frame.size.height, width: 20, height: 14)
        corner.center.x = icons.center.x
        corner.image = UIImage(named: "corner.png")
        corner.isHidden = true
        self.view.addSubview(corner)
    }
    
    // create dot
    fileprivate func createDotIcon(){
        
        dot.frame = CGRect(x: self.view.frame.size.width / 5 * 3, y: self.view.frame.size.height - 5, width: 7, height: 7)
        dot.center.x = self.view.frame.size.width / 5 * 3 + (self.view.frame.size.width / 5) / 2
        dot.backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 29/255, alpha: 1)
        dot.layer.cornerRadius = dot.frame.size.width / 2
        dot.isHidden = true
        self.view.addSubview(dot)
    }
    
}
