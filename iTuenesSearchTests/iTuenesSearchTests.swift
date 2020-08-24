//
//  iTuenesSearchTests.swift
//  iTuenesSearchTests
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//

import XCTest
@testable import iTuenesSearch

class iTuenesSearchTests: XCTestCase {
    
    
    func testItunesAPI()  {
        
        let expextation = expectation(description: "Testing iTuenes Search API")
        Album().fetchAlbums(String(format: API.albumsAPI, "all")) { (response, results, error) in
            XCTAssert(response?.statusCode == 200, error?.localizedDescription ?? "something wrong with API")
            XCTAssert( ( results?.count ?? 0 ) > 0, "No data to display the items")
            expextation.fulfill()
        }
        
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
