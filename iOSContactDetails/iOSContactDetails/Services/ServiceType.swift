//
//  ServiceType.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 27/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

protocol ServiceType {
    func getContactDetails(forType type: ContactInfoType) -> Promise<[ContactInfoResponse]>
    func addContactDetail(forInfo info: ContactInfoRequest) -> Promise<ContactInfoResponse>
    func editContactDetail(forID id: String) -> (_ info: ContactInfoRequest) -> Promise<ContactInfoResponse>
    func deleteContactDetail(forId id: String) -> Promise<Bool>
}

struct Service: ServiceType {
    let httpClient: HttpClientProtocol
    let decoder: DecodeTypeProtocol
    
    init(httpClient: HttpClientProtocol = HttClient(serverConfig: ServerConfig.production),
         decode: DecodeType = DecodeType()) {
        self.httpClient = httpClient
        self.decoder = decode
    }
    
    func getContactDetails(forType type: ContactInfoType) -> Promise<[ContactInfoResponse]> {
        return type
                |> getRoute(forType:)
                   >>> request()
    }
    
    func addContactDetail(forInfo info: ContactInfoRequest) -> Promise<ContactInfoResponse> {
       return info
              |> Route.addContactInfo
                 >>> request()
    }
    
    func editContactDetail(forID id: String) -> (_ info: ContactInfoRequest) -> Promise<ContactInfoResponse> {
        return { (_ info: ContactInfoRequest) -> Promise<ContactInfoResponse> in
            return (id: id, data: info)
                   |> Route.editContactInfo
                      >>> self.request()
        }
    }
    
    func deleteContactDetail(forId id: String) -> Promise<Bool> {
        return id
               |> Route.deleteContactInfo
                  >>> request()
    }
    
    private func request<T: Decodable>() -> (Route) -> Promise<T> {
        return httpClient.request(route:)
               >>> decoder.decode(response:)
    }
    
    private func getRoute(forType type: ContactInfoType) -> Route {
        switch type {
        case .contact(let id):
            return Route.getContactInfo(id)
        case .all:
            return Route.getContactInfo(nil)
        }
    }
}
