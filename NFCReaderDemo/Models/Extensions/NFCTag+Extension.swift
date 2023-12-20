//
//  NFCTag+Extension.swift
//  NFCReaderDemo
//
//  Created by Huei-Der Huang on 2023/12/11.
//

import Foundation
import CoreNFC

extension NFCTag: CustomStringConvertible {
    public var description: String {
        switch self {
            case .feliCa(_): return "FeliCa"
            case .iso15693(_): return "ISO-15693"
            case .iso7816(_): return "ISO-7816"
            case let .miFare(tag):
                switch tag.mifareFamily {
                    case .unknown: return "ISO-14443A"
                    case .ultralight : return "MiFare Ultralight"
                    case .plus: return "MiFare Plus"
                    case .desfire: return "MiFare DESFire"
                    @unknown default: return "Invalid tag"
                }
            @unknown default: return "Invalid tag"
        }
    }
}
