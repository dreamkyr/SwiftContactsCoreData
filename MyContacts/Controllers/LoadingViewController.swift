//
//  LoadingViewController.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    var webservice: ContactService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webservice = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let contacts = DataManager.shared.getContacts()
        if contacts.count > 0 {
            self.gotoContactList(contacts: contacts)
        } else {
            progressBar.startAnimating()
            self.webservice.fetchContacts()
        }
    }
    
    func gotoContactList(contacts: [Contact]) {
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "contactNav") as? UINavigationController
        let vc = nav?.viewControllers.first as? ContactsViewController
        vc?.contacts = contacts
        self.present(nav!, animated: true, completion: nil)
    }
}

extension LoadingViewController: ContactService {    
    func webServiceGetError(_ error: NetworkError) {
        progressBar.stopAnimating()
        print(error.localizedDescription)
    }
    
    func webServiceGetResponse(data: [Contact]) {
        DataManager.shared.saveContacts(contacts: data)
        progressBar.stopAnimating()
        self.gotoContactList(contacts: DataManager.shared.getContacts())
    }
}

