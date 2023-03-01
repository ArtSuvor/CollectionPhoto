//
//  APITarget.swift
//  CollectionPhoto
//
//  Created by Art on 01.03.2023.
//

import Foundation

enum APITarget {
// MARK: - Cases -
    case photos(searchText: String, pageNumber: Int)
    
// MARK: - Private properties -
    private var baseURL: URL? { URL(string: "https://api.unsplash.com") }
    
    private var path: String {
        switch self {
            case .photos: return "/search/photos"
        }
    }
    
    private var queryItems: [String: String] {
        switch self {
            case let .photos(searchText, pageNumber): return ["query": searchText,
                                                              "page": "\(pageNumber)",
                                                              "per_page": "30"]
        }
    }
    
    private var headers: [String: String]? {
        ["Authorization": "Client-ID 7PNbpeUaJNgVJSL0Yz8uo9b3MHgwNNMNdScZoZMSeD8"]
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
            case .photos: return .get
        }
    }
    
    private var body: Encodable? {
        switch self {
            default: return nil
        }
    }
    
// MARK: - Public methods -
    func makeURLRequest(encoder: JSONEncoder) async throws -> URLRequest {
        let url = try self.makeURL()
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.httpMethod.rawValue
        
        if let body = self.body {
            request.httpBody = try await Task.detached { [encoder] in
                try encoder.encode(body)
            }.value
        }
        return request
    }
    
// MARK: - Private methods -
    private func makeURL() throws -> URL {
        guard let url = baseURL else { throw URLError(.badURL) }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        components.path = self.path

        if !queryItems.isEmpty {
            components.queryItems = queryItems.map(URLQueryItem.init)
        }
        
        guard let url = components.url else { throw URLError(.badURL) }
        print(url)
        return url
    }
}
