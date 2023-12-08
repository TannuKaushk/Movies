//
//  MockService.swift
//  TheMoviesTests
//
//  Created by Tannu Kaushik on 24/04/22.
//

import XCTest
@testable import TheMovies

class MockMovieService: MoviesService {
    
    var mockMovieData: MovieData?
    var mockError: HTTPError = .unableToCompleteRequest
    var mockMovieDetail: MovieDetail?
    var mockMovieDetailError: HTTPError = .unableToCompleteRequest
    
    func getMovieList(for page: Int) async throws -> MovieData {
        if let result = mockMovieData {
            return result
        }
        throw mockError
    }
    
    func getMovieDetail(for movieId: Int) async throws -> MovieDetail {
        if let result = mockMovieDetail {
            return result
        }
        throw mockMovieDetailError
    }
}
