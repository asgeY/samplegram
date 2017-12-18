//
//  Regx.swift
//  Instagram
//
//  Created by Bobby Negoat on 11/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

enum Validate {

case username(_: String)
case fullname(_: String)
case password(_: String)
case email(_: String)
case URL(_ :String)

     var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        
        switch self {
            
        case let .username(str):
            predicateStr = "^[a-zA-Z0-9_.]*$"
            currObject = str
        case let .fullname(str):
            predicateStr = "^[a-zA-Z0-9_.]*$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]*$"
            currObject = str
        case let .email(str):
            predicateStr = "[A-Z0-9a-z._%+-]{4,7}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            currObject = str
        case let .URL(str):
            predicateStr = "www.+[A-Z0-9a-z._%+-]+.[A-Za-z]{2,3}"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with:currObject)
    }
}
