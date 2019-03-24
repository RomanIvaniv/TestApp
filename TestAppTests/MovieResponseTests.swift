//
//  MovieResponseTests.swift
//  TestAppTests
//
//  Created by Roman Ivaniv on 3/25/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import XCTest
@testable import TestApp

class MovieResponseTests: XCTestCase {

    override func setUp() {
       
    }

    override func tearDown() {
      
    }
    
    func testMovieListValidJSON() {
        // given
        let json = stubbedResponse("MovieListValid")!
        let resp = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String: Any]
        // when
        let movies = MovieItem.createMovies(from: resp)
        // then
        XCTAssertFalse(movies.isEmpty, "No items on valid response!")
    }
    
    func testMovieListBrokenJSON() { //missing last square bracket
        // given
        let json = stubbedResponse("MovieListBroken")!
        // when
        let resp = try? JSONSerialization.jsonObject(with: json, options: .allowFragments)
        // then
        XCTAssertNil(resp, "Response is broken!")
    }
    
    func testMovieListCreationWithEmptyData() {
        // given
        let emptyDictionary = [String: Any]()
        // when
        let movies = MovieItem.createMovies(from: emptyDictionary)
        // then
        XCTAssertTrue(movies.isEmpty, "No items on valid response!")
    }
    
    //Here can be more tests for different type of reponse, movie seach(filter) logic, MovieItem init, etc
    
    // MARK: - Helpers
    
    private func stubbedResponse(_ filename: String) -> Data! {
        let bundle = Bundle(for: MovieResponseTests.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }

}
