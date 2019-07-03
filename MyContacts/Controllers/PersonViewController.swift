//
//  PersonViewController.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit
import MessageUI

protocol PersonViewControllerDelegate {
    func onClickSave(contact: Contact)
    func onClickDelete(id: Int)
}

class PersonViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var personDelegate: PersonViewControllerDelegate?
    var index: Int?
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavitationBar()
        
        self.tableView.tableFooterView = UIView()
    }
    
    func initNavitationBar() {
        self.navigationItem.title = contact?.name
        self.navigationItem.leftBarButtonItem?.title = "Contacts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(self.onClickSave(sender:)))
    }
    
    @objc func onClickAction(sender: UIButton) {
        switch sender.tag {
        case 6:
            self.callPhone()
        case 7:
            self.sendEmail()
        case 8:
            self.onClickDelete()
        default:
            return
        }
    }
    
    @objc func onClickSave(sender: UIBarButtonItem) {
        if (self.personDelegate != nil) {
            self.personDelegate?.onClickSave(contact: self.contact!)
            let alertVC = UIAlertController(title: nil, message: "Successfully saved.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc func onClickDelete() {
        if (self.personDelegate != nil) {
            let alertVC = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (code) in
                self.personDelegate?.onClickDelete(id: self.contact!.id)
                self.navigationController?.popViewController(animated: true)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func createStaticCellView(title: String, value: String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell") as? StaticTableViewCell
        cell?.labelTitle.text = title
        cell?.labelValue.text = value
        return cell!
    }
    
    func createEditCellView(title: String, value: String, tag: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell") as? EditTableViewCell
        cell?.labelTitle.text = title
        cell?.textValue.text = value
        cell?.textValue.tag = tag
        cell?.textValue.delegate = self
        return cell!
    }
    
    func createActionCellView(title: String, tag: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as? ActionTableViewCell
        cell?.btnAction.setTitle(title, for: .normal)
        cell?.btnAction.tag = tag
        if tag == 8 {
            cell?.btnAction.setTitleColor(UIColor.red, for: .normal)
        }
        cell?.btnAction.addTarget(self, action: #selector(self.onClickAction(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func callPhone() {
        let phoneNumber = contact?.phone.split(separator: " ")[0]
        if let url = URL(string: "tel://\(phoneNumber ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alertVC = UIAlertController(title: "Error", message: "Invalid phone number", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.contact!.email])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Error", message: "Can't send email in this device.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
}

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 6, 7, 8:
            return 50
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return self.createStaticCellView(title: "Name", value: contact!.name)
        case 1:
            return self.createEditCellView(title: "Email", value: contact!.email, tag: indexPath.row)
        case 2:
            return self.createEditCellView(title: "Phone", value: String(contact!.phone.split(separator: " ")[0]), tag: indexPath.row)
        case 3:
            return self.createStaticCellView(title: "Company", value: contact!.company.name)
        case 4:
            return self.createStaticCellView(title: "Website", value: contact!.website)
        case 5:
            return self.createStaticCellView(title: "Address", value: "\(contact!.address.formatedAddress())")
        case 6:
            return self.createActionCellView(title: "Call", tag: indexPath.row)
        case 7:
            return self.createActionCellView(title: "Send Email", tag: indexPath.row)
        case 8:
            return self.createActionCellView(title: "Delete", tag: indexPath.row)
        default:
            return UITableViewCell()
        }
        
    }
}

extension PersonViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            self.contact?.email = textField.text!
        }
        if textField.tag == 2 {
            self.contact?.phone = textField.text!
        }
    }
}

extension PersonViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
