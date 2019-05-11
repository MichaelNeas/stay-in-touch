//
//  StringExtensions.swift
//  StayInTouchTests
//
//  Created by Michael Neas on 5/10/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import XCTest

class StringExtensions: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertFalse(isPhone("blabla"), "Not a phone number")
        XCTAssertTrue(isPhone("+1(222)333-44-55"), "is a phone number")
        XCTAssertTrue(isPhone("+42 555.123.4567"), "is a phone number")
        XCTAssertTrue(isPhone("+1-(800)-123-4567"), "is a phone number")
        XCTAssertTrue(isPhone("+7 555 1234567"), "is a phone number")
        XCTAssertTrue(isPhone("+7(926)1234567"), "is a phone number")
        XCTAssertTrue(isPhone("(926) 1234567"), "is a phone number")
        XCTAssertTrue(isPhone("+79261234567"), "is a phone number")
        XCTAssertTrue(isPhone("926 1234567"), "is a phone number")
        XCTAssertTrue(isPhone("9261234567"), "is a phone number")
        XCTAssertTrue(isPhone("1234567"), "is a phone number")
        XCTAssertTrue(isPhone("123-4567"), "is a phone number")
        XCTAssertTrue(isPhone("123-89-01"), "is a phone number")
        XCTAssertTrue(isPhone("495 1234567"), "is a phone number")
        XCTAssertTrue(isPhone("469 123 45 67"), "is a phone number")
        XCTAssertTrue(isPhone("8 (926) 1234567"), "is a phone number")
        XCTAssertTrue(isPhone("89261234567"), "is a phone number")
        XCTAssertTrue(isPhone("926.123.4567"), "is a phone number")
        XCTAssertTrue(isPhone("415-555-1234"), "is a phone number")
        XCTAssertTrue(isPhone("650-555-2345"), "is a phone number")
        XCTAssertTrue(isPhone("(416)555-3456"), "is a phone number")
        XCTAssertTrue(isPhone("202 555 4567"), "is a phone number")
        XCTAssertTrue(isPhone("4035555678"), "is a phone number")
        XCTAssertTrue(isPhone(" 1 416 555 9292"), "is a phone number")
    }
    
    private func isPhone(_ string: String) -> Bool {
        return string.isValid(regex: .phone)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
