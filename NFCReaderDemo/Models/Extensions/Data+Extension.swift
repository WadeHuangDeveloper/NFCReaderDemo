//
//  Data+Extension.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation

extension Data {
    public func toHexString() -> String {
        return !self.isEmpty ? "0x\(self.map { String(format: "%02hx ", $0)}.joined())" : ""
    }
    
    public func toUTF8String() -> String {
        if let uhf8String = String(data: self, encoding: .utf8) {
            return uhf8String
        } else {
            return "N/A"
        }
    }
}
