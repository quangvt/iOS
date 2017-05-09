//
//  AppDelegate.swift
//  NSURLSession
//
//  Created by Quang Vu on 01/May/2017.
//  Copyright © 2017 Quang Vu. All rights reserved.
//


import UIKit

class Person: NSObject {
//    var id : String? // ? optional
    var id : Int
    var name : String?
    var phone : Int?
    var email: String?
    var city : String?
    
    init(information : [String : AnyObject?])
    {
//        let id = information["id"] as? String
//        self.id = id
        // Auto Increment
        let id = information["id"] as! Int
        self.id = id
        let name = information["name"] as? String
        self.name = name
        let phone = information["phone"] as? Int
        self.phone = phone
        let email = information["email"] as? String
        self.email = email
        let city = information["city"] as? String
        self.city = city
    }
}
