//
//  Common.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 21/04/22.
//

import Foundation
/**
 Struct to hold static strings
 */
struct Common {
    
    static let apiKey: String = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    static let baseURL: String = "https://api.themoviedb.org/3"
    static let imageBaseURL: String = "https://image.tmdb.org/t/p/w500"
    
    struct URLs {
        static let listURL: String = "discover/movie"
        static let detailURL: String = "movie"
    }
}
