//
//  ServerConfig.swift
//  iOSContactDetails
//
//  Created by Balraj Singh on 26/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import Foundation

/**
 A type that knows the location of a CabsLocation API.
 */
public protocol ServerConfigType {
    var apiBaseUrl: URL { get }
    var environment: EnvironmentType { get }
}

public enum EnvironmentType: String {
    case production = "Production"
}

public struct ServerConfig: ServerConfigType {
    public fileprivate(set) var apiBaseUrl: URL
    public fileprivate(set) var environment: EnvironmentType
    
    public static let production: ServerConfigType = ServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.production)")!,
        environment: EnvironmentType.production
    )
}

public enum Secrets {
    public enum Api {
        public enum Endpoint {
            public static let production = "gojek-contacts-app.herokuapp.com"
        }
    }
}
