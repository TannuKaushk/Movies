//
//  MovieListRequest.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 21/04/22.
//

import Foundation
/**
Movies list fetch request
 */
struct MovieListRequest : NetworkRequest {
    let pageNumber: Int
    let apiKey: String = Common.apiKey
    
    var method: HTTPMethod {
        return .GET
    }
    var serviceName: String {
        return Common.URLs.listURL
    }
}
extension MovieListRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case apiKey = "api_key"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(apiKey, forKey: .apiKey)
        try container.encode(pageNumber, forKey: .pageNumber)
    }
}
