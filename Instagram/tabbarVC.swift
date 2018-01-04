//
//  tabbarVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

// global variables of icons
var icons = UIScrollView()
var corner = UIImageView()
var dot = UIView()

class tabbarVC: UITabBarController {

   fileprivate var storedImageViewArr:[UIImageView?] = []
    
private var times = [Int].init(repeating: 0, count: 5)
private var tempTimes = [Int].init(repeating: 0, count: 5)
    
private let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    
override func viewDidLoad() {
        super.viewDidLoad()

  // create image views
 getImageView()
  
//set path
    setPath()
    
        //set tab bar layer
setTabBarLayer()
   
        // creare total icons
createIcons()
        
        // create corner
createCornerIcon()
        
        // create dot
createDotIcon()
        
        // call function of all type of notifications
query(["like"], image: UIImage(named: "likeIcon.png")!)
query(["follow"], image: UIImage(named: "followIcon.png")!)
query(["mention", "comment"], image: UIImage(named: "commentIcon.png")!)
        
// hide icons objects
setHideItemAnimation()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}// tabbarVC class over line

//custom functions
extension tabbarVC{
    
    fileprivate func getImageView(){
times[0] = 1
storedImageViewArr = [0,1,2,3,4].map{ (offset) -> UIImageView in
let tempImageView = self.tabBar.subviews[offset].subviews.first as! UIImageView
tempImageView.contentMode = .center
return tempImageView
        }
        
    }
    
    fileprivate func setPath(){
        
        bounceAnimation.values = [1.0 ,0.6, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
    }
    
    //set tab bar layer
    fileprivate func setTabBarLayer(){
        
        // color of background
        self.tabBar.barTintColor = .white
        
        // disable translucent
        self.tabBar.isTranslucent = false
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 241.0 / 255.0, alpha: 1)
    }
    
    // creare total icons
    fileprivate func createIcons(){
        
        // create total icons
        icons.frame = CGRect(x: self.view.frame.size.width / 5 * 3 + 10, y: self.view.frame.size.height - self.tabBar.frame.size.height * 2 - 7, width: 50, height: 35)
        icons.layer.cornerRadius = 5
    self.view.addSubview(icons)
    }
    
    // create corner
    fileprivate func createCornerIcon(){
        
        corner.frame = CGRect(x: icons.frame.origin.x, y: icons.frame.origin.y + icons.frame.size.height, width: 20, height: 14)
        corner.center.x = icons.center.x
        corner.image = UIImage(named: "corner.png")
        corner.isHidden = true
   self.view.addSubview(corner)
    }
    
    // create dot
    fileprivate func createDotIcon(){
        
        dot.frame = CGRect(x: self.view.frame.size.width / 5 * 3, y: self.view.frame.size.height - 5, width: 7, height: 7)
        dot.center.x = self.view.frame.size.width / 5 * 3 + (self.view.frame.size.width / 5) / 2
        dot.backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 29/255, alpha: 1)
        dot.layer.cornerRadius = dot.frame.size.width / 2
        dot.isHidden = true
      self.view.addSubview(dot)
    }
    
    // multiple query
    fileprivate func query (_ type:[String], image:UIImage) {
        
        let query = PFQuery(className: "news")
        query.whereKey("to", equalTo: PFUser.current()!.username!)
        //query.whereKey("checked", equalTo: "no")
        query.whereKey("type", containedIn: type)
        query.countObjectsInBackground (block: { (count, error) in
            if error == nil {
                if count > 0 {
        self.placeIcon(image, text: "\(count)")
                }
        } else {print(error!.localizedDescription)}
        })
    }
    
    // multiple icons
   fileprivate func placeIcon (_ image:UIImage, text:String) {
        
        // create separate icon
        let view = UIImageView(frame: CGRect(x: icons.contentSize.width, y: 0, width: 50, height: 35))
        view.image = image
        icons.addSubview(view)
        
        // create label
        let label = UILabel(frame: CGRect(x: view.frame.size.width / 2, y: 0, width: view.frame.size.width / 2, height: view.frame.size.height))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        view.addSubview(label)
        
        // update icons view frame
        icons.frame.size.width = icons.frame.size.width + view.frame.size.width - 4
        icons.contentSize.width = icons.contentSize.width + view.frame.size.width - 4
        icons.center.x = self.view.frame.size.width / 5 * 4 - (self.view.frame.size.width / 5) / 4
        
        // unhide elements
        corner.isHidden = false
        dot.isHidden = false
    }
  
    fileprivate func setHideItemAnimation(){
        
        // hide icons objects
        UIView.animate(withDuration: 1, delay: 4, options: [], animations: {
            icons.alpha = 0
            corner.alpha = 0
            dot.alpha = 0
        }, completion: nil)
    }
    
    fileprivate func setAnimation(at index: Int)
{
self.storedImageViewArr[index]?.layer.removeAllAnimations()
self.storedImageViewArr[index]?.layer.add(bounceAnimation, forKey: nil)
    }
}

//UITabBarControllerDelegate
extension tabbarVC{
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if times[item.tag] == 0{
            setAnimation(at: item.tag)
            times = tempTimes
            times[item.tag] += 1;return
        }}
}
