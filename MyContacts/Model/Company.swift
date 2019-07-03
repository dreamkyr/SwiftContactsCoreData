//
//  Company.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class Company: NSObject {
    var name = ""
    var catchPhrase = ""
    var bs = ""
    
    override init() {
        
    }
    
    init(dict:[String:Any]) {
        if let val = dict["name"] as? String                 { name = val }
        if let val = dict["catchPhrase"] as? String        { catchPhrase = val }
        if let val = dict["bs"] as? String                      { bs = val }
    }
}
