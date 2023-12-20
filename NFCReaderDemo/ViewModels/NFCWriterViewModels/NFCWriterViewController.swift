//
//  NFCWriterViewController.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import UIKit
import CoreNFC
import os

class NFCWriterViewController: UIViewController, NFCNDEFReaderSessionDelegate, UITableViewDataSource, UITableViewDelegate, NFCNDEFPayloadTypeDelegate {
    
    
    // MARK: - Properties
    let reuseIdentifier = "NFCNDEFRecordTableViewCell"
    let typeViewControllerIdentifier = "NFCNDEFPayloadTypeTableViewController"
    let recordViewControllerIdentifier = "NFCNDEFRecordTextViewController"
    var delegate: NFCNDEFPayloadTypeDelegate?
    var records: [NFCRecordData] = []
    private var session: NFCNDEFReaderSession?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var recordTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var writeButton: UIButton!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        initializeProperties()
    }
    
    // MARK: - IBActions
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        guard let title = sender.title else { return }
        sender.title = title == "Edit" ? "Done" : "Edit"
        self.recordTableView.setEditing(title == "Edit" ? true : false, animated: true)
    }
    
    @IBAction func addARecord(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: typeViewControllerIdentifier) as! NFCNDEFPayloadTypeTableViewController
        controller.delegate = delegate
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func removeAllRecords(_ sender: Any) {
        guard records.count > 0 else { return }
        
        let alertController = UIAlertController(title: "Warning!", message: "Delete all records?", preferredStyle: .alert)
        let yesAlertAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.records = []
            self.recordTableView.reloadData()
        }
        let cancelAlertAction = UIAlertAction(title: "cancel", style: .cancel)
        alertController.addAction(yesAlertAction)
        alertController.addAction(cancelAlertAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func writeTag(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAlertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near an NFC tag."
        session?.begin()
    }
    
    
    // MARK: - Methods
    
    private func initializeUI() {
        editBarButtonItem.title = "Edit"
        recordTableView.dataSource = self
        recordTableView.delegate = self
        recordTableView.rowHeight = 65
        addButton.setTitle("Add a record", for: .normal)
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 10
        removeButton.setTitle("Remove all records", for: .normal)
        removeButton.clipsToBounds = true
        removeButton.layer.cornerRadius = 10
        writeButton.setTitle("Write", for: .normal)
        writeButton.clipsToBounds = true
        writeButton.layer.cornerRadius = 10
    }
    
    private func initializeProperties() {
        records = [NFCRecordData]()
        delegate = self
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // If necessary, you may perform additional operations on session start.
        // At this point RF polling is enabled.
        os_log("readerSessionDidBecomeActive")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // If necessary, you may handle the error. Note session is no longer valid.
        // You must create a new session to restart RF polling.
        os_log("readerSession didInvalidateWithError %@", error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        os_log("readerSession didDetectNDEFs")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        os_log("readerSession didDetect")
        
        if tags.count > 1 {
            session.invalidate(errorMessage: "More than 1 tags found. Please present only 1 tag.")
            return
        }
        
        // You connect to the desired tag.
        guard let detectedNFCTag = tags.first else {
            session.invalidate(errorMessage: "There is no records.")
            return
        }
        
        session.connect(to: detectedNFCTag) { (error: Error?) in
            if error != nil {
                session.restartPolling()
                return
            }
            
            // You then query the NDEF status of tag.
            detectedNFCTag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
                if error != nil {
                    session.invalidate(errorMessage: "Fail to determine NDEF status. Please try again.")
                    return
                }
                
                switch status {
                case .notSupported:
                    session.invalidate(errorMessage: "Tag is not NDEF compliant.")
                case .readOnly:
                    session.invalidate(errorMessage: "Tag is read only.")
                case .readWrite:
                    let records = self.records.map(\.nfcRecord)
                    let message = NFCNDEFMessage(records: records)
                    detectedNFCTag.writeNDEF(message) { (error: Error?) in
                        if error != nil {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                        }
                        session.invalidate()
                    }
                    
                @unknown default:
                    session.invalidate(errorMessage: "Unknown NDEF tag status.")
                }
            }
        }
    }
    
    // MARK: - NFCNDEFPayloadTypeDelegate
    
    func didGetTextRecord(_ record: NFCRecordData) {
        self.records.insert(record, at: 0)
        self.recordTableView.reloadData()
    }
    
    func didGetURIRecord(_ record: NFCRecordData) {
        self.records.insert(record, at: 0)
        self.recordTableView.reloadData()
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
