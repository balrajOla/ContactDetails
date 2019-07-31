//
//  String+Call.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func extractAll(type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingResult] {
        var result = [NSTextCheckingResult]()
        do {
            let detector = try NSDataDetector(types: type.rawValue)
            result = detector.matches(in: self, range: NSRange(startIndex..., in: self))
        } catch { print("ERROR: \(error)") }
        return result
    }
    
    func to(type: NSTextCheckingResult.CheckingType) -> String? {
        let phones = extractAll(type: type).compactMap { $0.phoneNumber }
        switch phones.count {
        case 0: return nil
        case 1: return phones.first
        default: print("ERROR: Detected several phone numbers"); return nil
        }
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}

func call(mobNumber: String) {
    guard   let number = mobNumber.to(type: .phoneNumber),
        let url = URL(string: "tel://\(number.onlyDigits())"),
        UIApplication.shared.canOpenURL(url) else { return }
    if #available(iOS 10, *) {
        UIApplication.shared.open(url)
    } else {
        UIApplication.shared.openURL(url)
    }
}
