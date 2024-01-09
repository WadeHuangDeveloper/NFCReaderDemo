//
//  NFCReaderViewController+DataSource.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/10.
//

import Foundation
import UIKit

extension NFCReaderViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detectedNFCTagData = detectedNFCTagData else {
            return 0
        }
        
        return detectedNFCTagData.message.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detectedNFCTagData = detectedNFCTagData else {
            return NFCNDEFMessageTableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! NFCNDEFMessageTableViewCell
        cell.recordCountLabel.text = detectedNFCTagData.message.records.count.description + (detectedNFCTagData.message.records.count > 1 ? " records" : " record")
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detectedNFCTagData = detectedNFCTagData else { return }
        let controller = self.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier) as! NFCNDEFPayloadTableViewController
        controller.setNFCTagData(detectedNFCTagData)
        controller.setNFCNDEFPayload(detectedNFCTagData.message.records[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.detectedNFCTagData = nil
            self.messageTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
