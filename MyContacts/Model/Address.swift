//
//  Address.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class Address: NSObject {
    var street = ""
    var suite = ""
    var city = ""
    var zipcode = ""
    var geo: [Double] = [0.0, 0.0]
    
    override init() {
        
    }
    
    init(dict:[String:Any]) {
        if let val = dict["street"] as? String                 { street = val }
        if let val = dict["suite"] as? String                  { suite = val }
        if let val = dict["city"] as? String                    { city = val }
        if let val = dict["zipcode"] as? String               { zipcode = val }
        if let val = dict["geo"] as? [String: Any] {
            if let lat = val["lat"] as? String,  let lng = val["lng"] as? String {
                geo = [Double(lat), Double(lng)] as! [Double]
            }
        }
    }
    
    func formatedAddress() -> String {
        return "\(self.street) \(self.suite) \(self.city) \(self.zipcode)"
    }
}
