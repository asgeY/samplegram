//
//  commentsNav.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class commentsNav: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //set navigation bar attributes
        setNavBarAtrributes()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//commentsNav class over line

//custom functions
extension commentsNav{
    
    //set navigation bar attributes
    fileprivate func setNavBarAtrributes(){
    
        // color of background of nav controller
    self.navigationBar.setGradientBackground(colors: [UIColor(hex: "FC466B"),UIColor(hex: "3F5EFB")])
    }
}
