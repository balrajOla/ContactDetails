//
//  ContactDetailUsecase.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

protocol ContactDetailUsecaseProtocol {
    func getContactDetail(forID id: String) -> Promise<SavedContactDetails>
    func addOrUpdateContactDetail(forID id: String?) -> (_ details: ContactDetails) -> Promise<SavedContactDetails>
}

struct ContactDetailUsecase: ContactDetailUsecaseProtocol {
    let crudUsecase: ContactDetailsCRUDUsecaseProtocol
    
    init(crud: ContactDetailsCRUDUsecaseProtocol = ContactDetailsCRUDUsecase(service: Service())) {
        self.crudUsecase = crud
    }
    
    func getContactDetail(forID id: String) -> Promise<SavedContactDetails> {
       return id |> crudUsecase.getContact(forID:)
    }
    
    func addOrUpdateContactDetail(forID id: String?) -> (_ details: ContactDetails) -> Promise<SavedContactDetails> {
        return (id.map { $0 |> self.crudUsecase.editContact(forID:) } ?? self.crudUsecase.createContact)
    }
}
