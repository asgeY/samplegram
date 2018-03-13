//
//  feedNav.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class feedNav: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar gradient effect
        setNavBarAttributes()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//feedNav class over line

//custom functions
extension feedNav{
    
    //set navigation bar gradient effect
    fileprivate func setNavBarAttributes(){
        
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "40E0D0"),UIColor(hex: "FF8C00"),UIColor(hex: "FF0080")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}
