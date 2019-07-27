//
//  ContactInfoRequest.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 27/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct ContactInfoRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let favorite: Bool
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case favorite
    }
}

