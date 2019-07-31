//
//  RouterUnitTest.swift
//  RouterUnitTest
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest
@testable import iOSContactDetails

class RouterUnitTest: XCTestCase {

    var configRoute: ((_ route: Route) -> URLRequest?)?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        configRoute = Route.httpRequest(serverConfig: ServerConfig.production)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetContactByIDUrlRequest() {
        let route = Route.getContactInfo("123")
        let request = configRoute?(route)
        
        XCTAssertNotNil(request, "Request value cannot be nil")
        XCTAssertTrue(request?.url?.absoluteString.contains("123") ?? false, "This request should contain the id")
    }
}
