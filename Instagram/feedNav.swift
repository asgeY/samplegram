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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension feedNav{
    
    //set navigation bar gradient effect
    fileprivate func setNavBarAttributes(){
       
        self.navigationBar.setGradientBackground(colors: [UIColor(hex: "355C7D"),UIColor(hex: "6C5B7B"),UIColor(hex: "C06C84")])
        
        // disable translucent
        self.navigationBar.isTranslucent = false
    }
}
