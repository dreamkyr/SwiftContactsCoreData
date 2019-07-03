//
//  ContactsViewController.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    var webservice: ContactService!
    
    @IBOutlet weak var tableView: UITableView!
    
    var progressBar: UIActivityIndicatorView!
    
    var contacts: [Contact] = []
    
    var favoriteContacts: [Contact] = []
    var generalContacts: [Contact] = []
    
    var sectionTitles = ["FAVORITES", "CONTACTS"]
    
    var selectedContact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webservice = self
        
        self.initNavigationBar()
        
        self.tableView.tableFooterView = UIView()
        self.sortContacts()
    }
    
    func initNavigationBar() {
        self.navigationItem.title = "Contacts"
        let resetBtn = UIBarButtonItem.init(title: "Reset", style: .done, target: self, action: #selector(self.onClickReset(sender:)))
        progressBar = UIActivityIndicatorView(style: .gray)
        progressBar.hidesWhenStopped = true
        let progresView = UIBarButtonItem.init(customView: progressBar)
        self.navigationItem.rightBarButtonItems = [resetBtn, progresView]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Map", style: .done, target: self, action: #selector(self.onClickMap(sender:)))
    }
    
    func sortContacts() {
        favoriteContacts = contacts.filter({ $0.favorite == true }).sorted(by: { $0.name < $1.name })
        generalContacts = contacts.filter({ $0.favorite == false }).sorted(by: { $0.name < $1.name })
    }
    
    @objc func onClickReset(sender: UIBarButtonItem) {
        self.progressBar.startAnimating()
        self.webservice.fetchContacts()
    }
    
    @objc func onClickMap(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "segueMap", sender: self)
    }
    
    @objc func onClickFavorite(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = sender.tag
        if sender.isSelected {
            let contact = self.generalContacts[index]
            contact.favorite = true
            favoriteContacts.append(contact)
            self.favoriteContacts = self.favoriteContacts.sorted(by: { $0.name < $1.name })
            self.generalContacts.remove(at: index)
        } else {
            let contact = self.favoriteContacts[index]
            contact.favorite = false
            self.generalContacts.append(contact)
            self.generalContacts = self.generalContacts.sorted(by: { $0.name < $1.name })
            self.favoriteContacts.remove(at: index)
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "seguePerson":
            let vc = segue.destination as! PersonViewController
            vc.personDelegate = self
            vc.contact = self.selectedContact!
        case "segueMap":
            let vc = segue.destination as! MapViewController
            vc.contacts = self.contacts
        default:
            return
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return favoriteContacts.count
        default:
            return generalContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? ContactTableViewCell
        switch indexPath.section {
        case 0:
            cell?.updateData(contact: self.favoriteContacts[indexPath.row])
        default:
            cell?.updateData(contact: self.generalContacts[indexPath.row])
        }
        cell?.btnStar.tag = indexPath.row
        cell?.btnStar.addTarget(self, action: #selector(onClickFavorite(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedContact = indexPath.section == 0 ? self.favoriteContacts[indexPath.row] : self.generalContacts[indexPath.row]
        self.performSegue(withIdentifier: "seguePerson", sender: self)
    }
}

extension ContactsViewController: PersonViewControllerDelegate {
    func onClickSave(contact: Contact) {
        let index = self.contacts.firstIndex(where: {$0.id == contact.id})!
        self.contacts[index] = contact
        self.tableView.reloadData()
    }
    
    func onClickDelete(id: Int) {
        let index = self.contacts.firstIndex(where: {$0.id == id})!
        self.contacts.remove(at: index)
        self.sortContacts()
        self.tableView.reloadData()
    }
}

extension ContactsViewController: ContactService {
    func webServiceGetError(_ error: NetworkError) {
        self.progressBar.stopAnimating()
        print(error.localizedDescription)
    }
    func webServiceGetResponse(data: [Contact]) {
        self.progressBar.stopAnimating()
        DataManager.shared.saveContacts(contacts: data)
        self.contacts = DataManager.shared.getContacts()
        self.sortContacts()
        self.tableView.reloadData()
    }
}
