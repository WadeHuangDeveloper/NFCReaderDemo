//
//  NFCNDEFPayloadTypeTableViewCell.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/13.
//

import UIKit

class NFCNDEFPayloadTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
