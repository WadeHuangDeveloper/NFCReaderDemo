//
//  NFCNDEFPayloadTableViewController.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import UIKit
import CoreNFC

class NFCNDEFPayloadTableViewController: UITableViewController {
    
    // MARK: Properties
    
    private var data: NFCTagData?
    private var record: NFCNDEFPayload?

    // MARK: IBOutlets
    
    @IBOutlet weak var tagTypeLabel: UILabel!
    @IBOutlet weak var typeNameFormatLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var payloadLabel: UILabel!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUI()
        updateWithProperties()
    }

    // MARK: Methods
    
    private func initializeUI() {
        self.tagTypeLabel.text = ""
        self.typeNameFormatLabel.text = ""
        self.idLabel.text = ""
        self.sizeLabel.text = ""
        self.statusLabel.text = ""
        self.payloadLabel.text = ""
        self.tableView.rowHeight = 50
        self.tableView.allowsSelection = false
    }
    
    func setNFCTagData(_ data: NFCTagData) {
        self.data = data
    }
    
    func setNFCNDEFPayload(_ record: NFCNDEFPayload) {
        self.record = record
    }
    
    private func updateWithProperties() {
        guard let data = data,
              let record = record else { return }
        
        self.tagTypeLabel.text = data.type.description
        self.typeNameFormatLabel.text = record.typeNameFormat.description
        self.idLabel.text = record.identifier.toHexString()
        self.sizeLabel.text = "\(data.message.length) \(data.message.length > 1 ? " bytes" : " byte")"
        self.statusLabel.text = data.status.description
        
        guard let text = record.wellKnownTypeTextPayload().0,
              let locale = record.wellKnownTypeTextPayload().1 else { return }
        
        self.payloadLabel.text = "Language: \(locale.identifier.uppercased())\nText: \(text)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
