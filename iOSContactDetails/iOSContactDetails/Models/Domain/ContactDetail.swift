//
//  ContactDetail.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

struct Contacts {
    let info: [SavedContactDetails]
}

struct SavedContactDetails {
    let id: Int
    let details: ContactDetails
}

struct ContactDetails {
    let name: PersonnelInfo
    let contactInfo: ContactInfo?
    let isFav: Bool
}

struct PersonnelInfo {
    let firstName: String
    let lastName: String
    let profilePic: String?
}

enum ContactInfo {
    case phoneNumber(String)
    case emailID(String)
    case both((phoneNumber: String, emailID: String))
    
    func getPhoneNumber() -> String? {
        switch self {
        case .phoneNumber(let phNo):
            return (phNo.count > 0 ? phNo : nil)
        case .both(let data):
            return (data.phoneNumber.count > 0 ? data.phoneNumber : nil)
        default:
            return nil
        }
    }
    
    func getEmailID() -> String? {
        switch self {
        case .emailID(let email):
            return (email.count > 0 ? email : nil)
        case .both(let data):
            return (data.emailID.count > 0 ? data.emailID: nil)
        default:
            return nil
        }
    }
    
    static func create(phoneNumber: String?, emailID: String?) -> ContactInfo? {
        switch (phoneNumber, emailID) {
        case (.none, .none):
            return nil
        case (.none, .some(let emID)):
            return .emailID(emID)
        case (.some(let phNo), nil):
            return .phoneNumber(phNo)
        case (.some(let phNo), .some(let emID)):
            return .both((phNo, emID))
        }
    }
}

func getContactInfoRequest(fromContactDetails contactDetails: ContactDetails) -> ContactInfoRequest {
   return ContactInfoRequest(firstName: contactDetails.name.firstName, lastName: contactDetails.name.lastName, email: contactDetails.contactInfo?.getEmailID(), phoneNumber: contactDetails.contactInfo?.getPhoneNumber(), favorite: contactDetails.isFav)
}

func getSavedContactDetails(fromResponse response: ContactInfoResponse) -> SavedContactDetails {
   return SavedContactDetails(id: response.id, details: ContactDetails(name: PersonnelInfo(firstName: response.firstName, lastName: response.lastName, profilePic: response.profilePic), contactInfo: ContactInfo.create(phoneNumber: response.phoneNumber, emailID: response.email), isFav: response.favorite))
}

