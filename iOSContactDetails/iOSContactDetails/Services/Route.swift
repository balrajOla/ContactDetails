//
//  Route.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 26/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

internal enum Route {
    case addContactInfo(ContactInfoRequest)
    case editContactInfo((id: String, data: ContactInfoRequest))
    case getContactInfo(String?)
    case deleteContactInfo(String)
    
    internal var requestProperties:
        (method: HTTPMethod, path: String, query: [String: Any]) {
        switch self {
        case .addContactInfo(let contactInfoReq):
            return (HTTPMethod.post, "/contacts.json", contactInfoReq.dictionary ?? [String: Any]())
        case .editContactInfo(let reqData):
            return (HTTPMethod.put, "/contacts/\(reqData.id).json", reqData.data.dictionary ?? [String: Any]())
        case .getContactInfo(let id):
            return (HTTPMethod.get, id.map{ return "/contacts/\($0).json" } ?? "/contacts.json", [String: Any]())
        case .deleteContactInfo(let id):
            return (HTTPMethod.delete, "/contacts/\(id).json", [String: Any]())
        }
    }
    
    static func absoluteURL(serverConfig: ServerConfigType)
        -> (_ route: Route)
        -> URL? {
            return { (_ route: Route) -> URL? in
                let absoluteURL = (route.requestProperties.path.lowercased().contains("https") || route.requestProperties.path.lowercased().contains("http")) ? route.requestProperties.path : serverConfig.apiBaseUrl.appendingPathComponent(route.requestProperties.path).absoluteString
                var url = URLComponents(string: absoluteURL)
                
                url?.queryItems = route.requestProperties.query.map { (item: (key: String, value: Any)) -> URLQueryItem in
                    URLQueryItem(name: item.0, value: (item.1 as? String))
                }
                
                return url?.url
            }
    }
}

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}
