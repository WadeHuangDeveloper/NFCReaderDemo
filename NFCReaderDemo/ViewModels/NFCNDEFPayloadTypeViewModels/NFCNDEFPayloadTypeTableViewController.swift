//
//  NFCNDEFPayloadTypeTableViewController.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/13.
//

import UIKit

class NFCNDEFPayloadTypeTableViewController: UITableViewController {

    var delegate: NFCNDEFPayloadTypeDelegate?
    let reuseIdentifier = "NFCNDEFPayloadTypeTableViewCell"
    let textViewControllerIdentifier = "NFCNDEFRecordTextViewController"
    let imageViewControllerIdentifier = "NFCNDEFRecordImageViewController"
    let payloadTypes: [String] = ["Text", "URI"]
    let payloadTypeDescriptions = ["Add a text record", "Add a URI record"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        self.tableView.rowHeight = 60
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payloadTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NFCNDEFPayloadTypeTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.typeLabel.text = payloadTypes[indexPath.row]
        cell.typeDescriptionLabel.text = payloadTypeDescriptions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let controller = self.storyboard?.instantiateViewController(withIdentifier: textViewControllerIdentifier) as! NFCNDEFRecordTextViewController
        controller.setWithPayloadType(row == 0 ? .text : .URI)
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
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
