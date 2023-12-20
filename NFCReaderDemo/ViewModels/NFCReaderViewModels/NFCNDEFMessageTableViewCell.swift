//
//  NFCNDEFMessageTableViewCell.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/10.
//

import UIKit

class NFCNDEFMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var recordCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
