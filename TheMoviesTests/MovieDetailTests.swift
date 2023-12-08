//
//  MovieDetailTests.swift
//  TheMoviesTests
//
//  Created by Tannu Kaushik on 24/04/22.
//

import XCTest
@testable import TheMovies

class MovieDetailTests: XCTestCase {
    private var sut: MovieDetailViewModelImpl!
    private var imageService: MockImageService!
    let movieDetail: MovieDetail = {
        return MovieDetail(adult: false, backdropPath: nil, belongsToCollection: nil, budget: 100, genres: [], homepage: nil, id: 111, imdbID: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: 1, posterPath: "posterPath", productionCompanies: [], productionCountries: [], releaseDate: "2022-01-30", revenue: 100, runtime: 156, spokenLanguages: [], status: Status.planned, tagline: nil, title: "Title1", video: false, voteAverage: 8, voteCount: 1)
    }()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        imageService = MockImageService()
        sut = MovieDetailViewModelImpl(movieDetail: movieDetail, imageService: imageService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        imageService = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_image_fetch_success() async {
        //Given
        let expectation = XCTestExpectation(description: "test_image_fetch_success")
        let expectedImage = "image data".data(using: .utf8)!
        imageService.mockData = expectedImage
        imageService.expectation = expectation
        imageService.validateInput = { (imagePath: String) in
            XCTAssertEqual(imagePath, "posterPath")
        }
        //When
        let data = await sut.getImageData()
        wait(for: [expectation], timeout: 5)
        //Then
        XCTAssertEqual(data, expectedImage)
    }
}
