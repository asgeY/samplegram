//
//  dropDownView.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

protocol selectCellDelegate{
    func tapToPhotoLibrary()
    func tapToReset()
}

class dropDownView: UIView,UITableViewDelegate, UITableViewDataSource {
    
    var dropDownOptions = [String]()
    
    var delegate: dropDownDelegate!
    
    var tapDelegate:selectCellDelegate?
    
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = .red
        self.backgroundColor = .clear
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
tableView.translatesAutoresizingMaskIntoConstraints=false
        
        self.addSubview(tableView)
        
tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
}//dropDownView class over line

//UITableViewDataSource
extension dropDownView{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
 cell.textLabel?.font = UIFont.init(name: "MedulaOne-Regular", size: 23)
        cell.textLabel?.textColor = .white
    cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = .red
        return cell
    }
}

//UITableViewDelegate
extension dropDownView{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dismissDropDown()
self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1{
            self.tapDelegate?.tapToReset()
        }else if indexPath.row == 0{
            self.tapDelegate?.tapToPhotoLibrary()
        }
    }
}

