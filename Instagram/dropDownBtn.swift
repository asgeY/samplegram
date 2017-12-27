//
//  dropDownBtn.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

protocol dropDownDelegate {
    func dismissDropDown()
}

class dropDownBtn:UIButton,dropDownDelegate{
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()
    
    var isOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        self.setImage(#imageLiteral(resourceName: "gear"), for: .normal)
        self.contentMode = .bottom
        dropView.delegate = self
dropView.translatesAutoresizingMaskIntoConstraints = false
        }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
dropView.leadingAnchor.constraint(equalTo: (self.superview?.layoutMarginsGuide.leadingAnchor)!).isActive = true
dropView.trailingAnchor.constraint(equalTo: (self.superview?.layoutMarginsGuide.trailingAnchor)!).isActive = true
height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {isOpen = true
UIView.animate(withDuration: 0.4, animations: {
self.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
})
NSLayoutConstraint.deactivate([self.height])
if self.dropView.tableView.contentSize.height > 150 {
    self.height.constant = 150
} else {self.height.constant = self.dropView.tableView.contentSize.height
}
NSLayoutConstraint.activate([self.height])
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
    self.dropView.layoutIfNeeded()
self.dropView.center.y += self.dropView.frame.height / 2
}, completion: nil)
} else {isOpen = false
UIView.animate(withDuration: 0.4, animations: {
self.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
})
NSLayoutConstraint.deactivate([self.height])
self.height.constant = 0
NSLayoutConstraint.activate([self.height])
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
self.dropView.center.y -= self.dropView.frame.height / 2
self.dropView.layoutIfNeeded()}, completion: nil)
}}
    
required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
        
}//dropDownBtn class over line

//custom functions
extension dropDownBtn{
    
     func dismissDropDown() {
        isOpen = false
    NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
self.dropView.center.y -= self.dropView.frame.height / 2
self.dropView.layoutIfNeeded()}, completion: nil)
    }
}
