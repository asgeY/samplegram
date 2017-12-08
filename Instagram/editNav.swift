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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension editNav{
    
    //set navigation bar attributes
    fileprivate func setNavBarAttributes(){
     
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "40E0D0"), UIColor(hex: "FF8C00"), UIColor(hex: "FF0080")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}
