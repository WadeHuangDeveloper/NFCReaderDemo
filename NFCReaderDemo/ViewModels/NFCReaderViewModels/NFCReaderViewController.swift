//
//  NFCReaderViewController.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/10.
//

import UIKit
import CoreNFC
import os

class NFCReaderViewController: UIViewController, NFCTagReaderSessionDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    let reuseIdentifier = "NFCNDEFMessageTableViewCell"
    let viewControllerIdentifier = "NFCNDEFPayloadTableViewController"
    var detectedNFCTagData: NFCTagData?
    private var session: NFCTagReaderSession?
    
    // MARK: - IBOutlets

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var readButton: UIButton!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        initializeProperties()
    }
    
    // MARK: - IBActions

    @IBAction func scanTag(_ sender: Any) {
        guard NFCTagReaderSession.readingAvailable else {
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
        
        session = NFCTagReaderSession(
            pollingOption: [.iso14443, .iso15693],
            delegate: self,
            queue: nil)
//        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near an NFC tag."
        session?.begin()
    }
    
    // MARK: - Methods
    
    private func initializeUI() {
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageTableView.rowHeight = 50
        readButton.setTitle("Read", for: .normal)
        readButton.clipsToBounds = true
        readButton.layer.cornerRadius = 10
    }
    
    private func initializeProperties() {
        
    }
    
    func updateWithDetectedNFCTagData(type: NFCTag, tag: NFCNDEFTag, status: NFCNDEFStatus, message: NFCNDEFMessage) -> Bool {
        DispatchQueue.main.async {
            let nfcTagData = NFCTagData(type: type, tag: tag, status: status, message: message)
            self.detectedNFCTagData = nfcTagData
            self.messageTableView.reloadData()
        }
        return true
    }
    
    /*
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
        let tag = tags.first!
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.restartPolling()
                return
            }
            
            // You then query the NDEF status of tag.
            tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
                if error != nil {
                    session.invalidate(errorMessage: "Fail to determine NDEF status. Please try again.")
                    return
                }
                
                tag.readNDEF { (message: NFCNDEFMessage?, error: Error?) in
                    if message == nil || error != nil {
                        session.invalidate(errorMessage: "Read tag error. Please try again.")
                        return
                    }
                    
                    if self.updateWithNDEFMessage(message!) {
                        session.alertMessage = "Read tag success."
                        session.invalidate()
                        return
                    } else {
                        session.invalidate(errorMessage: "Update error.")
                    }
                }
            }
        }
    }
    */
    
    // MARK: - NFCTagReaderSessionDelegate
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        // If necessary, you may perform additional operations on session start.
        // At this point RF polling is enabled.
        os_log("tagReaderSessionDidBecomeActive")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // If necessary, you may handle the error. Note session is no longer valid.
        // You must create a new session to restart RF polling.
        os_log("tagReaderSession didInvalidateWithError %@", error.localizedDescription)
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        os_log("tagReaderSession didDetect")
        
        if tags.count > 1 {
            session.invalidate(errorMessage: "More than 1 tags was found. Please present only 1 tag.")
            return
        }
        
        guard let detectedNFCTag = tags.first else {
            session.invalidate(errorMessage: "There is no records.")
            return
        }
        
        session.connect(to: detectedNFCTag) { (error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Connection error. Please try again.")
                return
            }
            
            var ndefTag: NFCNDEFTag
            
            switch detectedNFCTag {
            case let .iso7816(tag):
                ndefTag = tag
            case let .feliCa(tag):
                ndefTag = tag
            case let .iso15693(tag):
                ndefTag = tag
            case let .miFare(tag):
                ndefTag = tag
            @unknown default:
                session.invalidate(errorMessage: "Tag is invalid.")
                return
            }
            
            ndefTag.queryNDEFStatus() { (status: NFCNDEFStatus, _, error: Error?) in
                if status == .notSupported {
                    session.invalidate(errorMessage: "Tag not valid.")
                    return
                }
                
                ndefTag.readNDEF() { (message: NFCNDEFMessage?, error: Error?) in
                    if error != nil || message == nil {
                        session.invalidate(errorMessage: "Read error. Please try again.")
                        return
                    }
                    
                    if self.updateWithDetectedNFCTagData(type: tags.first!, tag: ndefTag, status: status, message: message!) {
                        session.alertMessage = "Tag read success."
                        session.invalidate()
                        return
                    }
                    
                    session.invalidate(errorMessage: "Tag not valid.")
                }
            }
        }
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
