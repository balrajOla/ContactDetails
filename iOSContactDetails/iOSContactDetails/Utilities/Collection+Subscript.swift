//
//  Collection+Subscript.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
