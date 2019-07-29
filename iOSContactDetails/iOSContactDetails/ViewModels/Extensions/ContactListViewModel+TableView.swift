//
//  ContactDetailsViewModel+TableView.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 28/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

extension ContactListViewModel {
    func getTotalContactsCount() -> Int {
        return self.contacts.map { res -> Int in
            switch res {
            case .fulfilled(let value):
                return value.info.count
            default:
                return 0
            }
        } ?? 0
    }
    
    func getContactCellViewModel(forIndex index: Int) -> ContactCellViewModel? {
        return self.contacts.flatMap { res -> ContactCellViewModel? in
            switch res {
            case .fulfilled(let value):
                return value.info[safe: index].map { $0 |> ContactCellViewModel.init(info: ) }
            default:
                return nil
            }
        }
    }
    
    func getContactDetailsViewModel(forIndex index: Int) -> ContactDetailsViewModel? {
        return self.contacts.flatMap { res -> ContactDetailsViewModel? in
            switch res {
            case .fulfilled(let value):
                return value.info[safe: index].map { ContactDetailsViewModel.init(contactDetails: $0, usecase: ContactDetailUsecase()) }
            default:
                return nil
            }
        }
    }
}
