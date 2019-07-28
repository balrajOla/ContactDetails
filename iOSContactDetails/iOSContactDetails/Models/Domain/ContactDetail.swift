//
//  ContactDetail.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct Contacts {
    let info: [ContactDetail]
}

struct ContactDetail {
    let id: String
    let name: PersonnelName
    let contactInfo: ContactInfo?
}

struct PersonnelName {
    let firstName: String
    let lastName: String
}

enum ContactInfo {
    case phoneNumber(String)
    case emailID(String)
    case both((phoneNumber: String, emailID: String))
}


