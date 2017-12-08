//
//  tabbarVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tab bar layer
   setTabBarLayer()
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
    }
    
    
}
