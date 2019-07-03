//
//  EditTableViewCell.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textValue: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickEdit(_ sender: Any) {
        self.textValue.becomeFirstResponder()
    }
}
