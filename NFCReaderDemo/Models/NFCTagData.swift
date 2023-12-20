//
//  NFCTagData.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation
import CoreNFC

class NFCTagData: NSObject {
    
    var type: NFCTag
    var tag: NFCNDEFTag
    var status: NFCNDEFStatus
    var message: NFCNDEFMessage
    
    init(type: NFCTag, tag: NFCNDEFTag, status: NFCNDEFStatus, message: NFCNDEFMessage) {
        self.type = type
        self.tag = tag
        self.status = status
        self.message = message
    }
}
