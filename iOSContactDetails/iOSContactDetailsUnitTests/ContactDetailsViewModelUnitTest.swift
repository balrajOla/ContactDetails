//
//  ContactDetailsViewModelUnitTest.swift
//  iOSContactDetailsUnitTests
//
//  Created by Balraj Singh on 31/07/19.
//  Copyright © 2019 Balraj Singh. All rights reserved.
//

import XCTest
import PromiseKit
@testable import iOSContactDetails

class ContactDetailsViewModelUnitTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTrackMemoryLeak() {
        let vm = ContactDetailsViewModel(contactDetails: SavedContactDetails(id: 1,
                                                                             details: ContactDetails(name: PersonnelInfo(firstName: "abc",
                                                                                                                         lastName: "xyz",
                                                                                                                         profilePic: nil),
                                                                                                     contactInfo: nil,
                                                                                                     isFav: false)),
                                         usecase: ContactDetailUsecase())
        
        _ = vm.loadContactDetails()
        _ = vm.toggleIsFav()
        
        self.trackForMemoryLeaks(vm)
    }
    
    func testLoadContactDetailRequestedID() {
        let requestedID = 1
        let mockUsecase = MockUsecase()
        
        let vm = ContactDetailsViewModel(contactDetails: SavedContactDetails(id: requestedID,
                                                                             details: ContactDetails(name: PersonnelInfo(firstName: "abc",
                                                                                                                         lastName: "xyz",
                                                                                                                         profilePic: nil),
                                                                                                     contactInfo: nil,
                                                                                                     isFav: false)),
                                         usecase: mockUsecase)
        
        // Create an expectation for async task
        let expectation = XCTestExpectation(description: "Load contact")
        
        vm.loadContactDetails()
            .done { _ in }
            .catch { _ in }
            .finally {
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 60.0)
        
        XCTAssertTrue(mockUsecase.requestedID == String(requestedID), "The requested id is not correct")
    }
}

enum MockUsecaseError: Error {
    case notImplemented
}

class MockUsecase: ContactDetailUsecaseProtocol {
    var requestedID: String?
    
    func getContactDetail(forID id: String) -> Promise<SavedContactDetails> {
        self.requestedID = id
        return Promise<SavedContactDetails>(error: MockUsecaseError.notImplemented)
    }
    
    func addOrUpdateContactDetail(forID id: String?)
        -> (ContactDetails)
        -> Promise<SavedContactDetails> {
            return { (ContactDetails) -> Promise<SavedContactDetails> in
        return Promise<SavedContactDetails>(error: MockUsecaseError.notImplemented)
            }
    }
}
