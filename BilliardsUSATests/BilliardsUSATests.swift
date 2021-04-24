//
//  BilliardsUSATests.swift
//  BilliardsUSATests
//
//  Created by Tommy Bartocci on 3/17/21.
//

import XCTest
@testable import BilliardsUSA

class BilliardsUSATests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPoolHallParse() throws {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: "PoolHalls", withExtension: "json"))
        let data = try Data(contentsOf: url)
        
        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode(Search.self, from: data)
            print("Successful parse \(results)")
        } catch {
            XCTFail("Failed to parse: \(error)")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
