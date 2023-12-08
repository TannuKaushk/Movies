//
//  MoviesService.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 21/04/22.
//

import Foundation
/**
 MoviesService protocal to handle Network methods
 */
protocol MoviesService {
    func getMovieList(for page:Int) async throws -> MovieData
    func getMovieDetail(for movieId:Int) async throws -> MovieDetail
}

final class MoviesServiceImpl : MoviesService {
    
    fileprivate var networkService : NetworkService
    
    init(networkService : NetworkService) {
        self.networkService = networkService
    }
    
    // MARK: Network methods
    func getMovieList(for page:Int) async throws -> MovieData {
        do {
            let movieRequest = MovieListRequest(pageNumber: page)
            return try await networkService.http(request: movieRequest)
        } catch {
            throw error
        }
    }
    
    func getMovieDetail(for movieId:Int) async throws -> MovieDetail {
        do {
            let movieDetailRequest = MovieDetailRequest(movieId: movieId)
            return try await networkService.http(request: movieDetailRequest)
        } catch {
            throw error
        }
    }
}
