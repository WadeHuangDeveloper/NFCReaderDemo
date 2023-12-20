//
//  NFCNDEFRecordTableViewCell.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/13.
//

import UIKit

class NFCNDEFRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var payloadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
