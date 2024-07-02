//
//  MessageCell.swift
//  ChatApp
//
//  Created by hverda on 27/06/2024.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var leftAvatarImage: UIImageView!
    @IBOutlet weak var rightAvatarImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.layer.cornerRadius = frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
