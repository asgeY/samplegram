//
//  navVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class homeNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //set navigation bar attributes
        setNavBarAtrributes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}// navVC class over line

//custom functions
extension homeNav{

    //set navigation bar attributes
    fileprivate func setNavBarAtrributes(){
        
       // color of background of nav controller
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "CC95C0"), UIColor(hex: "DBD4B4"), UIColor(hex: "7AA1D2")])
        
        // color of buttons in nav controller
        self.navigationBar.tintColor = UIColor.white
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }

}
