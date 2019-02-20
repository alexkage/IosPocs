//
//  OTPTokenTest.swift
//  IosPocsTests
//
//  Created by Jose Flavio Quispe Irrazabal on 20/2/17.
//  Copyright © 2019 AlexKage. All rights reserved.
//

import XCTest
@testable import IosPocs

class OTPTokenTest: XCTestCase {
    
    let data = Data(base64Encoded: "stringAEncriptar")
    var otp : TOTP!
    
    override func setUp() {
        otp = TOTP(secret: data!, digits: 6, timeInterval: 60, algorithm: .sha1)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOtpNotNilBasicAttributes() {
        
        XCTAssertNotNil(otp?.algorithm)
        XCTAssertNotNil(otp?.digits)
        XCTAssertNotNil(otp?.timeInterval)
        
    }
    
    func testCorrectTotpAttrsValues(){
        
        XCTAssertEqual(6, otp?.digits)
        XCTAssertEqual(30, otp?.timeInterval)
        XCTAssertEqual(.sha1, otp?.algorithm)
    }
    
    func testTokenGenerated(){
        // the same secondsPast1970 for testing purposes
        XCTAssertEqual("769930", otp.generate(secondsPast1970: 10000))
        
    }
    
    func testValidateOTPTime(){
        XCTAssertFalse(otp.validateTime(time: 0))
    }
    
}
