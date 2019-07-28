//
//  ContactDetailsCRUDUsecase.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

protocol ContactDetailsCRUDUsecaseProtocol {
    func createContact(forDetail detail: ContactDetails) -> Promise<SavedContactDetails>
    func editContact(forID id: String) -> (_ detail: ContactDetails) -> Promise<SavedContactDetails>
    func getAllContacts() -> Promise<Contacts>
    func getContact(forID id: String) -> Promise<SavedContactDetails>
    func deleteContact(forID id: String) -> Promise<Bool>
}

struct ContactDetailsCRUDUsecase: ContactDetailsCRUDUsecaseProtocol {
    let service: ServiceType
    
    init(service: ServiceType) {
        self.service = service
    }
    
    func createContact(forDetail detail: ContactDetails) -> Promise<SavedContactDetails> {
        return detail
               |> getContactInfoRequest(fromContactDetails:)
                  >>> service.addContactDetail(forInfo:)
                  >>> { $0.map(getSavedContactDetails(fromResponse:)) }
    }
    
    func editContact(forID id: String) -> (_ detail: ContactDetails) -> Promise<SavedContactDetails> {
        return getContactInfoRequest(fromContactDetails:)
               >>> (id |> service.editContactDetail(forID:))
               >>> { $0.map(getSavedContactDetails(fromResponse:)) }
    }
    
    func getAllContacts() -> Promise<Contacts> {
        return service.getContactDetails(forType: .all)
               |> { $0.map { Contacts(info: $0.map(getSavedContactDetails(fromResponse:))) } }
    }
    
    func getContact(forID id: String) -> Promise<SavedContactDetails> {
        return service.getContactDetails(forType: .contact(id))
               |> { $0.map { $0.map(getSavedContactDetails(fromResponse:)).first! } }
    }
    
    func deleteContact(forID id: String) -> Promise<Bool> {
        return id |> service.deleteContactDetail(forId:)
    }
}
