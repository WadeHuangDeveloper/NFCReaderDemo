//
//  NFCNDEFRecordTextViewController.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/14.
//

import UIKit
import CoreNFC

class NFCNDEFRecordTextViewController: UIViewController, UITextFieldDelegate {

    var delegate: NFCNDEFPayloadTypeDelegate?
    private var payloadType: NFCNDEFPayloadType?
    private var record: NFCRecordData?
    
    @IBOutlet weak var recordTypeLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        self.inputTextField.delegate = self
        self.inputTextField.becomeFirstResponder()
        
        guard let payloadType = payloadType else { return }
        self.recordTypeLabel.text = payloadType.description
        
        guard let record = record else { return }
        self.inputTextField.text = record.nfcRecord.payload.toUTF8String()
    }
    
    @objc 
    private func handleDone() {
        guard let delegate = delegate,
              let text = self.inputTextField.text else { return }
        
        if (payloadType == .text) {
            guard let record = NFCNDEFPayload.wellKnownTypeTextPayload(string: text, locale: Locale.current) else { return }
            let payloadData = NFCRecordData(.text, record)
            delegate.didGetTextRecord(payloadData)
        } else {
            guard let url = URL(string: text),
                  let record = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else { return }
            let payloadData = NFCRecordData(.URI, record)
            delegate.didGetURIRecord(payloadData)
        }
        
        guard let viewControllers = self.navigationController?.viewControllers else { return }
        for viewController in viewControllers {
            if viewController is NFCWriterViewController {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
    }
    
    @objc
    private func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    func setWithPayloadType(_ payloadType: NFCNDEFPayloadType) {
        self.payloadType = payloadType
    }
    
    func setWithRecord(_ record: NFCRecordData) {
        self.record = record
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
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
