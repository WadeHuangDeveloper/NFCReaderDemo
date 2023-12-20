//
//  NFCNDEFPayloadTypeDelegate.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/13.
//

import Foundation
import UIKit
import CoreNFC

public protocol NFCNDEFPayloadTypeDelegate {
    func didGetTextRecord(_ record:NFCRecordData)
    func didGetURIRecord(_ record:NFCRecordData)
}
