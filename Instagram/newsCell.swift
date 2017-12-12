//
//  newsCell.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/12/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class newsCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var infoLbl: UILabel!
 
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set alignments
        setCellViewsAlignment()
        
        //set ava attributes
        setCellViewsAttributes()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}//newsCell class over line

//custom fucntions
extension newsCell{
    
    //set alignments
    fileprivate func setCellViewsAlignment(){
        
        // constraints
avaImg.translatesAutoresizingMaskIntoConstraints = false
usernameBtn.translatesAutoresizingMaskIntoConstraints = false
infoLbl.translatesAutoresizingMaskIntoConstraints = false
dateLbl.translatesAutoresizingMaskIntoConstraints = false
        
self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ava(40)]-10-[username]-7-[info]-7-[date]",options: [], metrics: nil, views: ["ava":avaImg, "username":usernameBtn, "info":infoLbl, "date":dateLbl]))
        
self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[ava(40)]-10-|",
options: [], metrics: nil, views: ["ava":avaImg]))
        
self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[username(30)]",
options: [], metrics: nil, views: ["username":usernameBtn]))
        
self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[info(30)]",options: [], metrics: nil, views: ["info":infoLbl]))
        
self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[date(30)]",options: [], metrics: nil, views: ["date":dateLbl]))
}
    
fileprivate func setCellViewsAttributes(){
        
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
}



