//
//  NFCNDEFStatus+Extension.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation
import CoreNFC

extension NFCNDEFStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notSupported: return "Not Supported"
        case .readOnly: return "Read Only"
        case .readWrite: return "Read/Write"
        @unknown default: return "Invalid tag"
        }
    }
}
