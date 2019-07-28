//
//  ContactsUsecase.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

protocol ContactsUsecaseProtocol {
    func getContacts() -> Promise<Contacts>
}

struct ContactsUsecase: ContactsUsecaseProtocol {
    let crudUsecase: ContactDetailsCRUDUsecaseProtocol
    
    init(crud: ContactDetailsCRUDUsecaseProtocol = ContactDetailsCRUDUsecase(service: Service())) {
        self.crudUsecase = crud
    }
    
    func getContacts() -> Promise<Contacts> {
        return self.crudUsecase.getAllContacts()
    }
}
