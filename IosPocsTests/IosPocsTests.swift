//
//  CajaPiuraMVPTests.swift
//  CajaPiuraMVPTests
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import XCTest
@testable import IosPocs

class IosPocsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTexfields(){
        let customsTextFields = CustomTextFieldView()
        let textfield0 = customsTextFields.textfield0
        XCTAssertEqual(textfield0?.text?.count, 1, "Must have one character")
    }

}
