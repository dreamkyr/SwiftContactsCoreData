//
//  Contact.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var id = 0
    var name = ""
    var username = ""
    var email = ""
    var phone = ""
    var website = ""
    var favorite = false
    var address =  Address()
    var company = Company()
    
    override init() {
        
    }
    
    init(dict:[String:Any]) {
        if let val = dict["id"] as? Int                           { id = val }
        if let val = dict["name"] as? String                 { name = val }
        if let val = dict["username"] as? String           { username = val }
        if let val = dict["email"] as? String                  { email = val }
        if let val = dict["phone"] as? String                 { phone = val }
        if let val = dict["website"] as? String               { website = val }
        if let val = dict["favorite"] as? Bool                  { favorite = val }
        if let val = dict["address"] as? [String: Any]     { address = Address.init(dict: val) }
        if let val = dict["company"] as? [String: Any]   { company = Company.init(dict: val) }
    }
}
