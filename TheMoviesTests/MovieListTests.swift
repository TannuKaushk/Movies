//
//  TheMoviesTests.swift
//  TheMoviesTests
//
//  Created by Tannu Kaushik on 19/04/22.
//

import XCTest
@testable import TheMovies

class MovieListTests: XCTestCase {
    private var sut: ListViewModelImpl!
    private var movieService: MockMovieService!
    private var imageService: MockImageService!
    private var actions: MoviesViewModelActions!
    
    let movieData: MovieData = {
        let results: [Result] = [
            Result(posterPath: "/poster", adult: false, overview: "", releaseDate: "2022-01-30", genreIDS: [], id: 111, originalTitle: "", originalLanguage: "", title: "Title1", backdropPath: nil, popularity: 0, voteCount: 1, video: false, voteAverage: 8),
            Result(posterPath: "/poster", adult: false, overview: "", releaseDate: "2022-02-11", genreIDS: [], id: 112, originalTitle: "", originalLanguage: "", title: "Title2", backdropPath: nil, popularity: 0, voteCount: 2, video: false, voteAverage: 9)]
        return MovieData(page: 1, results: results, totalResults: 20, totalPages: 2)
    }()
    
    let movieDetail: MovieDetail = {
        return MovieDetail(adult: false, backdropPath: nil, belongsToCollection: nil, budget: 100, genres: [], homepage: nil, id: 111, imdbID: nil, originalLanguage: nil, originalTitle: nil, overview: nil, popularity: 1, posterPath: nil, productionCompanies: [], productionCountries: [], releaseDate: "2022-01-30", revenue: 100, runtime: 156, spokenLanguages: [], status: Status.planned, tagline: nil, title: "Title1", video: false, voteAverage: 8, voteCount: 1)
    }()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        movieService = MockMovieService()
        imageService = MockImageService()
        sut = ListViewModelImpl(service: movieService, imageService: imageService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        movieService = nil
        imageService = nil
        sut = nil
        actions = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func test_movie_list_fetch_success() {
        //Given
        let expectation = XCTestExpectation(description: "test_movie_list_fetch_success")
        movieService.mockMovieData = movieData
        
        sut.didStartLoading = {
            XCTAssert(true, "didStartLoading")
        }
        sut.didStopLoading = {
            XCTAssert(true, "didStopLoading")
        }
        
        sut.didReload = {
            expectation.fulfill()
            XCTAssert(true, "didReload list")
        }
        //When
        sut.loadData()
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(self.sut.getListCount() == movieData.results.count, "Movie list should have 2 items in array as mocked")
    }
    
    func test_movie_list_fetch_failure() {
        //Given
        let expectation = XCTestExpectation(description: "test_movie_list_fetch_failure")
        
        movieService.mockError = .invalidResponse
        sut.didStopLoading = {
            XCTAssert(true, "didStopLoading")
        }
        sut.didShowError = {(errorTitle, errorMessage) in
            expectation.fulfill()
            XCTAssert(errorMessage == HTTPError.invalidResponse.errorDescription, "Invalid Response tested")
        }
        //When
        sut.loadData()
        wait(for: [expectation], timeout: 5)
        //Then
        XCTAssertTrue(self.sut.getListCount() == 0, "movie list should be empty")
    }
    func test_movie_detail_fetch_on_selection() {
        //Given
        let expectation = XCTestExpectation(description: "test_movie_list_fetch_success")
        let expectationFetchDetail = XCTestExpectation(description: "test_movie_detail_fetch_on_selection")
        actions = MoviesViewModelActions(showMovieDetail: { movieDetail in
            expectationFetchDetail.fulfill()
            //Then
            XCTAssert(true, "Movie details fetched")
        })
        sut = ListViewModelImpl(service: movieService, actions: actions, imageService: imageService)
        movieService.mockMovieData = movieData
        movieService.mockMovieDetail = movieDetail
        
        sut.didReload = {
            expectation.fulfill()
            XCTAssert(true, "didReload")
        }
        //When
        sut.loadData()
        wait(for: [expectation], timeout: 5)
        
        sut.didSelectItem(at: 0)
        wait(for: [expectationFetchDetail], timeout: 5)
        
    }
    func test_movie_detail_fetch_failure() {
        //Given
        let expectationFetchList = XCTestExpectation(description: "test_movie_list_fetch_success")
        let expectationFetchFailure = XCTestExpectation(description: "test_movie_detail_fetch_failure")
        
        movieService.mockMovieData = movieData
        movieService.mockMovieDetailError = .invalidData
        
        sut.didReload = {
            expectationFetchList.fulfill()
            XCTAssert(true, "didReload list")
        }
        sut.didStopLoading = {
            XCTAssert(true, "didStopLoading")
        }
        sut.didShowError = {(errorTitle, errorMessage) in
            expectationFetchFailure.fulfill()
            //Then
            XCTAssert(errorMessage == HTTPError.invalidData.errorDescription, "Invalid Data tested")
        }
        //When
        sut.loadData()
        wait(for: [expectationFetchList], timeout: 5)
        
        sut.didSelectItem(at: 0)
        wait(for: [expectationFetchFailure], timeout: 5)
        
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

