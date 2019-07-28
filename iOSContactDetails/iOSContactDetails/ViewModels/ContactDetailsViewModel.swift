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
    case noDataAvailable
    case unknown
}

class ContactDetailsViewModel {
    let usecase: ContactsUsecaseProtocol
    var contacts: Result<Contacts>?
    
    init(usecase: ContactsUsecaseProtocol) {
        self.usecase = usecase
    }
    
    func loadContacts() -> Promise<Bool> {
        return usecase.getContacts()
                      .tap {[weak self] result -> Void in self?.contacts = result  }
                      .map { _ in return true }
    }
}
