//
//  MockImageService.swift
//  TheMoviesTests
//
//  Created by Tannu Kaushik on 24/04/22.
//

import XCTest
@testable import TheMovies

class MockImageService: ImageService {
    var expectation: XCTestExpectation?
    var mockError: Error?
    var mockData = Data()
    var validateInput: ((String) -> Void)?

    func load(urlPath: String) async throws -> Data {
        if let error = mockError {
            expectation?.fulfill()
            throw error
        } else {
            validateInput?(urlPath)
            expectation?.fulfill()
            return mockData
        }
        
    }
}
