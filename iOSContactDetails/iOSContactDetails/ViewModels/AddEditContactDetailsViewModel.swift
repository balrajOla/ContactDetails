//
//  AddEditContactDetailsViewModel.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 29/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

enum AddEditContactDetailsViewModelError: Error {
    case emptyContactDetail
    case emptyFirstName
    case emptyLastName
    case emptyEmailID
    case emptyMobileNumber
    case invalidMobileNumber
    case invalidEmailID
    case selfUnInitialised
}

class AddEditContactDetailsViewModel {
    fileprivate var contactDetails: ContactDetails?
    let saveDetails: ((_ details: ContactDetails) -> Promise<SavedContactDetails>)
    let title: String
    
    init(contactDetails: SavedContactDetails, usecase: ContactDetailUsecaseProtocol) {
        self.contactDetails = contactDetails.details
        self.saveDetails = contactDetails.id |> String.init |> usecase.addOrUpdateContactDetail(forID:)
        self.title = "Edit Details"
    }
    
    init(usecase: ContactDetailUsecaseProtocol) {
        self.saveDetails = usecase.addOrUpdateContactDetail(forID: nil)
        self.title = "Add Details"
    }
    
    func saveContactDetails() -> Promise<String> {
       return (contactDetails |> validate(contactDetail:))
        .flatMap {[weak self] detail -> Promise<SavedContactDetails>? in
            guard let self = self else {
                return Promise<SavedContactDetails>(error: AddEditContactDetailsViewModelError.selfUnInitialised)
            }
            
        return detail
                |> self.saveDetails
        }?.map {[weak self] _ in
            return self?.contactDetails.map { "Contact details for \($0.name.firstName) \($0.name.lastName) has been saved!!!"} ?? "Contact details had been saved!!!" } ?? Promise<String>(error: AddEditContactDetailsViewModelError.emptyContactDetail)
    }
}

// Validation for contact details
extension AddEditContactDetailsViewModel {
    // Need to improve this func creating a generic zip fn over validationresult type
    func validate(contactDetail: ContactDetails?) -> ContactDetails? {
        guard let detail = contactDetail  else {
            return nil
        }
        
        switch (validate(firstName: detail.name.firstName)
              , validate(lastName: detail.name.lastName)
              , validate(emailID: detail.contactInfo?.getEmailID())
              , validate(phoneNumber: detail.contactInfo?.getPhoneNumber())) {
        case (.success(_ ), .success(_ ), .success(_ ), .success(_ )):
            return detail
        default:
            return nil
        }
    }
    
    func validate(firstName: String?) -> ValidationResult<String> {
        return required(firstName) >>= minLength(2)
    }
    
    func validate(lastName: String?) -> ValidationResult<String> {
        return required(lastName) >>= minLength(2)
    }
    
    func validate(emailID: String?) -> ValidationResult<String> {
        return (required(emailID) >>= minLength(1)) 
    }
    
    func validate(phoneNumber: String?) -> ValidationResult<String> {
        return (required(phoneNumber) >>= minLength(1))
    }
}

// get & setter of properties
extension AddEditContactDetailsViewModel {
    func getFirstName() -> String? {
        return contactDetails?.name.firstName
    }
    
    func getLastName() -> String? {
        return contactDetails?.name.lastName
    }
    
    func getEmailID() -> String? {
        return contactDetails?.contactInfo?.getEmailID()
    }
    
    func getPhoneNumber() -> String? {
        return contactDetails?.contactInfo?.getPhoneNumber()
    }
    
    func profilePic() -> URL? {
        return contactDetails?.name.profilePic.flatMap { URL(string: $0) }
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    /*
     This is tedious work of setting a value in immutable type can be solved using concept called as LENS & PRISM
     Will implement later. For now living with this.
     */
    func setFirstName(name: String) {
        self.contactDetails = ContactDetails(name: PersonnelInfo(firstName: name,
                                                                 lastName: self.contactDetails?.name.lastName ?? "",
                                                                 profilePic: self.contactDetails?.name.profilePic),
                                             contactInfo: self.contactDetails?.contactInfo,
                                             isFav: self.contactDetails?.isFav ?? false)
    }
    
    func setLastName(name: String) {
        self.contactDetails = ContactDetails(name: PersonnelInfo(firstName: self.contactDetails?.name.firstName ?? "",
                                                                 lastName: name,
                                                                 profilePic: self.contactDetails?.name.profilePic),
                                             contactInfo: self.contactDetails?.contactInfo,
                                             isFav: self.contactDetails?.isFav ?? false)
    }
    
    func setEmailID(email: String) {
        self.contactDetails = ContactDetails(name: PersonnelInfo(firstName: self.contactDetails?.name.firstName ?? "",
                                                                 lastName: self.contactDetails?.name.lastName ?? "",
                                                                 profilePic: self.contactDetails?.name.profilePic),
                                             contactInfo: ContactInfo.create(phoneNumber: self.contactDetails?.contactInfo?.getPhoneNumber(), emailID: email),
                                             isFav: self.contactDetails?.isFav ?? false)
    }
    
    func setPhoneNumber(number: String) {
        self.contactDetails = ContactDetails(name: PersonnelInfo(firstName: self.contactDetails?.name.firstName ?? "",
                                                                 lastName: self.contactDetails?.name.lastName ?? "",
                                                                 profilePic: self.contactDetails?.name.profilePic),
                                             contactInfo: ContactInfo.create(phoneNumber: number, emailID: self.contactDetails?.contactInfo?.getEmailID()),
                                             isFav: self.contactDetails?.isFav ?? false)
    }
}
