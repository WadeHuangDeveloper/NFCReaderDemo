//
//  NFCRecordData.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/18.
//

import Foundation
import CoreNFC

public class NFCRecordData: NSObject {
    
    var payloadType: NFCNDEFPayloadType
    var nfcRecord: NFCNDEFPayload
    
    init(_ payloadType: NFCNDEFPayloadType, _ record: NFCNDEFPayload) {
        self.payloadType = payloadType
        self.nfcRecord = record
    }
}
