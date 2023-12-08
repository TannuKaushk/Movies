//
//  NetworkService.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 21/04/22.
//

import Foundation
/**
 HTTP request method enum
 */
public enum  HTTPMethod  {
    case GET
    case POST
    
    public var description: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

/**
 Network Request protocol to process the network request
 */
public protocol NetworkRequest : Encodable {
    var method: HTTPMethod {get}
    var serviceName: String {get}
    var querySeperator: String {get}
}

extension NetworkRequest {
    public func queryString() throws ->  String? {
        if method == .GET {
            let jsonData = try? JSONEncoder().encode(self)
            if let jsonData = jsonData {
                let dictionary : [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] ?? [:]
                let queryString = dictionary.compactMap({ (key, value) -> String in
                    return "\(key)=\(value)"
                }).joined(separator: "&")
                return queryString
            }
        }
        return nil
    }
    fileprivate func jsonData() throws ->  Data? {
        if method == .POST {
            return try? JSONEncoder().encode(self)
        }
        return nil
    }
    
    public var querySeperator: String {
        return "/"
    }
}
/**
 Network error enum
 */
public enum  HTTPError : Error {
    
    case invalidRequest
    case unableToCompleteRequest
    case invalidResponse
    case invalidData
    
    /// Error Description
    public var errorDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .unableToCompleteRequest:
            return "Unable to complete your request. Please check your internet connection"
        case .invalidResponse:
            return "Invalid response from the server. Please try again"
        case .invalidData:
            return "The data received from the server was invalid. Please try again"
        }
    }
    /// Error title
    public var errorTitle: String {
        return "Network Error"
    }
}

/**
 Protocol to process the nework request
 */
protocol NetworkService {
    /**
     Handles network request
     */
    
    func http<T>(request: NetworkRequest) async throws -> T where T : Decodable
    
}



final class NetworkServiceImpl : NetworkService {
        
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    ///Generate URLRequest
    private func createRequest(_ request : NetworkRequest) throws -> URLRequest {
        
        var urlString = Common.baseURL + "/" + request.serviceName
        
        // Add Query String
        do {
            if let queryString = try request.queryString() {
                if queryString.count > 0{
                    urlString = urlString + "?" + queryString
                }
            }
        } catch {
            print (error)
            throw HTTPError.invalidRequest
        }
        
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let serviceURL = URL(string: encodedURLString)
        var urlrequest = URLRequest(url:serviceURL!)
        urlrequest.httpMethod = request.method.description
        
        if request.method == .POST {
            // Add POST body
            do {
                if let jsonData = try request.jsonData() {
                    urlrequest.httpBody = jsonData
                }
            } catch {
                print (error)
                throw HTTPError.invalidRequest
            }
        }
        
        return urlrequest
    }
    
    func http<T>(request: NetworkRequest) async throws -> T where T : Decodable {
        do {
            let urlRequest = try self.createRequest(request)
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                throw HTTPError.invalidResponse
            }
            do {
                return try data.decodeData() as T
            } catch {
                throw HTTPError.invalidResponse
            }
            
        } catch {
            throw HTTPError.invalidRequest
        }
    }
}

extension Data {
    func decodeData<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .deferredToDate
        return try JSONDecoder().decode(T.self, from: self)
    }
}

