//
//  ContactCellViewModel.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

class ContactCellViewModel {
    var contactInfo: SavedContactDetails
    
    init(info: SavedContactDetails) {
        self.contactInfo = info
    }
    
    func getName() -> String {
        return "\(contactInfo.details.name.firstName) \(contactInfo.details.name.lastName)"
    }
    
    func profilePic() -> URL? {
        return contactInfo.details.name.profilePic.flatMap { URL(string: $0) }
    }
    
    func isFav() -> Bool {
        return contactInfo.details.isFav
    }
}
