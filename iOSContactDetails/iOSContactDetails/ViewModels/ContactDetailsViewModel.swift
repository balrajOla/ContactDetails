//
//  ContactDetailsViewModel.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

enum ContactDetailsViewModelError: Error {
    case unIntialised
}

class ContactDetailsViewModel {
    var contactDetails: SavedContactDetails
    let usecase: ContactDetailUsecaseProtocol
    
    init(contactDetails: SavedContactDetails, usecase: ContactDetailUsecaseProtocol) {
        self.contactDetails = contactDetails
        self.usecase = usecase
    }
    
    func loadContactDetails() -> Promise<Bool> {
        return contactDetails.id
            |> { (val: Int) -> String in String.init(val) }
            >>> usecase.getContactDetail(forID:)
            >>> { $0.map({[weak self] (res: SavedContactDetails) -> Bool in
                self?.contactDetails = res
                return true
            }) }
    }
    
    func toggleIsFav() -> Promise<Bool> {
    return (!self.contactDetails.details.isFav
            |> self.setIsFav(value:)
            |> { $0.details }
            |> (self.contactDetails.id |> String.init |> self.usecase.addOrUpdateContactDetail(forID:)))
            .map({[weak self] (res: SavedContactDetails) -> Bool in
                self?.contactDetails = res
                return res.details.isFav
            })
    }
    
    func getFullName() -> String {
        return "\(contactDetails.details.name.firstName) \(contactDetails.details.name.lastName)"
    }
    
    func getMobileNumber() -> String {
        return contactDetails.details.contactInfo?.getPhoneNumber() ?? "--"
    }
    
    func getEmailID() -> String {
        return contactDetails.details.contactInfo?.getEmailID() ?? "--"
    }
    
    func profilePic() -> URL? {
        return contactDetails.details.name.profilePic.flatMap { URL(string: $0) }
    }
    
    func getAddEditContactDetailViewModel() -> AddEditContactDetailsViewModel {
        return AddEditContactDetailsViewModel(contactDetails: self.contactDetails, usecase: ContactDetailUsecase())
    }
    
    func getFavStatus() -> Bool {
        return self.contactDetails.details.isFav
    }
    
    func isMobileNumberEmpty() -> Bool {
        return contactDetails.details.contactInfo?.getPhoneNumber()?.isEmpty ?? true
    }
    
    func isEmailIDEmpty() -> Bool {
        return contactDetails.details.contactInfo?.getEmailID()?.isEmpty ?? true
    }
    
    func setIsFav(value: Bool) -> SavedContactDetails {
        self.contactDetails = SavedContactDetails(id: self.contactDetails.id,
                                                  details: ContactDetails(name: self.contactDetails.details.name,
                                                                          contactInfo: self.contactDetails.details.contactInfo,
                                                                          isFav: value))
        return self.contactDetails
    }
}
