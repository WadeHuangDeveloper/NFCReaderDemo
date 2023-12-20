//
//  NFCWriterViewController+DataSource.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation
import UIKit

extension NFCWriterViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NFCNDEFRecordTableViewCell
        let record = records[indexPath.row]
        cell.typeLabel.text = record.payloadType.description
        cell.sizeLabel.text = record.nfcRecord.payload.count.description + (record.nfcRecord.payload.count > 0 ? " bytes" : " byte")
        cell.payloadLabel.text = records[indexPath.row].nfcRecord.payload.toHexString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: recordViewControllerIdentifier) as! NFCNDEFRecordTextViewController
        controller.setWithRecord(records[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.recordTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            records.remove(at: indexPath.row)
            recordTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let record = records.remove(at: sourceIndexPath.row)
        records.insert(record, at: destinationIndexPath.row)
    }
}
