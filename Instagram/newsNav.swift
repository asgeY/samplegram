//
//  newsNav.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class newsNav: UINavigationController {

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
}// newsNav class over line

//custom functions
extension newsNav{
    
    //set navigation bar attributes
    fileprivate func setNavBarAtrributes(){
        
        // color of background of nav controller
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "BBD2C5"), UIColor(hex: "BBD2C5"), UIColor(hex: "292E49")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }

}
