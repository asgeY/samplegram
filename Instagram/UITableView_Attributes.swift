//
//  UITableView_Attributes.swift
//  Instagram
//
//  Created by Bobby Negoat on 12/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class UITableView_Attributes: UIView,UITableViewDelegate, UITableViewDataSource {

    var dropDownOptions = [String]()
    
    var tableView = UITableView(){
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor.red
        self.backgroundColor = UIColor.clear
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}//UITableView_Attributes class over line

//UITableViewDataSource
extension UITableView_Attributes{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
  cell.textLabel?.text = dropDownOptions[indexPath.row]
    cell.backgroundColor = .red
        return cell
    }
}

//UITableViewDelegate
extension UITableView_Attributes{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
