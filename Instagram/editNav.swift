//
//  ViewController.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class editNav: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navigation bar attributes
        setNavBarAttributes()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}//editNav class over line

//custom functions
extension editNav{
    
    //set navigation bar attributes
    fileprivate func setNavBarAttributes(){
        
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "00F260"), UIColor(hex: "0575E6")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}
