//
//  usersNav.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class usersNav: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar attributes
        setNavbarAttributes()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//usersNav class over line

//custom functions
extension usersNav{
    
    //set navigation bar attributes
    fileprivate func setNavbarAttributes(){
        
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "FEAC5E"),UIColor(hex: "C779D0"),UIColor(hex: "4BC0C8")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}


