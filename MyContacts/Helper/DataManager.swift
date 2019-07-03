//
//  DataManager.swift
//  MyContacts
//
//  Created by dreams on 6/21/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    static let shared = DataManager()
    
    override private init() {
        super.init()
    }
    
    func saveContacts(contacts: [Contact]) {
        
        self.deleteContacts()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let contactEntity = NSEntityDescription.entity(forEntityName: "Contacts", in: managedContext)
        let companyEntity = NSEntityDescription.entity(forEntityName: "Companies", in: managedContext)
        let addressEntity = NSEntityDescription.entity(forEntityName: "Addresses", in: managedContext)
        for item in contacts {
            let contact = NSManagedObject(entity: contactEntity!, insertInto: managedContext)
            contact.setValue(item.id, forKey: "id")
            contact.setValue(item.name, forKey: "name")
            contact.setValue(item.email, forKey: "email")
            contact.setValue(item.phone, forKey: "phone")
            contact.setValue(item.username, forKey: "username")
            contact.setValue(item.website, forKey: "website")
            
            let company = NSManagedObject(entity: companyEntity!, insertInto: managedContext)
            company.setValue(item.company.name, forKey: "name")
            company.setValue(item.company.catchPhrase, forKey: "catchPhrase")
            company.setValue(item.company.bs, forKey: "bs")
            company.setValue(contact, forKey: "contacts")
            
            let address = NSManagedObject(entity: addressEntity!, insertInto: managedContext)
            address.setValue(item.address.street, forKey: "street")
            address.setValue(item.address.suite, forKey: "suite")
            address.setValue(item.address.city, forKey: "city")
            address.setValue(item.address.zipcode, forKey: "zipcode")
            address.setValue(item.address.geo[0], forKey: "lat")
            address.setValue(item.address.geo[1], forKey: "lng")
            address.setValue(contact, forKey: "contacts")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("can't save. \(error), \(error.userInfo)")
        }

    }
    
    func getContacts() -> [Contact]{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        var contacts: [Contact] = []
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let contact = Contact()
                contact.id = data.value(forKey: "id") as! Int
                contact.name = data.value(forKey: "name") as! String
                contact.username = data.value(forKey: "username") as! String
                contact.email = data.value(forKey: "email") as! String
                contact.phone = data.value(forKey: "phone") as! String
                contact.website = data.value(forKey: "website") as! String
                
                let companyData = data.value(forKey: "companies") as! NSManagedObject
                contact.company.name = companyData.value(forKey: "name") as! String
                contact.company.catchPhrase = companyData.value(forKey: "name") as! String
                contact.company.bs = companyData.value(forKey: "bs") as! String
                
                let addressData = data.value(forKey: "addresses") as! NSManagedObject
                contact.address.street = addressData.value(forKey: "street") as! String
                contact.address.suite = addressData.value(forKey: "suite") as! String
                contact.address.city = addressData.value(forKey: "city") as! String
                contact.address.zipcode = addressData.value(forKey: "zipcode") as! String
                contact.address.geo[0] = addressData.value(forKey: "lat") as! Double
                contact.address.geo[1] = addressData.value(forKey: "lng") as! Double

                contacts.append(contact)
            }
        } catch {
            print("failed fetch")
        }
        return contacts
    }
    
    func deleteContacts() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contacts")
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(request)
        } catch {
            print("delete failed")
        }
    }
}
