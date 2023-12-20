//
//  NFCTypeNameFormat+Extension.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation
import CoreNFC

extension NFCTypeNameFormat: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty: return "Empty(0x00)"
        case .nfcWellKnown: return "NFC Well Known (0x01)"
        case .media: return "Media (0x02)"
        case .absoluteURI: return "Absolute URI (0x03)"
        case .nfcExternal: return "NFC External (0x04)"
        case .unknown: return "Unknown (0x05)"
        case .unchanged: return "Unchanged (0x06)"
        @unknown default: return "Invalid data"
        }
    }
}
