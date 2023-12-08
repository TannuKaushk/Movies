//
//  MovieDetailRequest.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 23/04/22.
//

import Foundation
/**
Movies details fetch request
 */
struct MovieDetailRequest : NetworkRequest {
    let apiKey: String = Common.apiKey
    let movieId: Int
    
    var method: HTTPMethod {
        return .GET
    }
    var serviceName: String {
        return "\(Common.URLs.detailURL)/\(movieId)"
    }
}
extension MovieDetailRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(apiKey, forKey: .apiKey)
    }
}
