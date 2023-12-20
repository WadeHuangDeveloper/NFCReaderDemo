//
//  NFCNDEFPayloadType.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/13.
//

import Foundation

public enum NFCNDEFPayloadType {
    case text
    case URI
}

extension NFCNDEFPayloadType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .text: return "Text"
        case .URI: return "URI"
        }
    }
}
