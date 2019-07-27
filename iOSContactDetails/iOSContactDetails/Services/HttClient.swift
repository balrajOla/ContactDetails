//
//  HttClient.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 26/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation
import PromiseKit

enum HttClientError: Error {
    case noInternet
    case notValidURL
    case unknown
}

protocol HttpClientProtocol {
    func request(route: Route) -> Promise<Data>
}

struct HttClient: HttpClientProtocol {
    public let serverConfig: (_ route: Route) -> URL?
    private let session: URLSession
    
    public init(serverConfig: ServerConfigType = ServerConfig.production) {
        self.serverConfig = Route.absoluteURL(serverConfig: serverConfig)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 300
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
    }
    
    func request(route: Route) -> Promise<Data> {
        // check for internet connection
        guard Network.isConnected() else {
            return Promise<Data>(error: HttClientError.noInternet)
        }
        
        let url = serverConfig(route)
        
        return Promise<Data> { seal in
            guard let completeURL = url else {
                seal.reject(HttClientError.notValidURL)
                return
            }
            
            let task = self.session.dataTask(with: completeURL, completionHandler: { (data, response, error) in
                if let err = error {
                    seal.reject(err)
                } else if let dt = data {
                    seal.fulfill(dt)
                } else {
                    seal.reject(HttClientError.unknown)
                }
            })
            
            task.resume()
        }
    }
}
