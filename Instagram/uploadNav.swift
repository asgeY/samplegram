//
//  uploadNav.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/9/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class uploadNav: UINavigationController {

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
}//uploadNav class over line

//custom functions
extension uploadNav{
    
    //set navigation bar attributes
    fileprivate func setNavbarAttributes(){
      
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "77A1D3"),UIColor(hex: "79CBCA"),UIColor(hex: "E684AE")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}

