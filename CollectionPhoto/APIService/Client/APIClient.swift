//
//  APIClient.swift
//  APIService
//
//  Created by Art on 01.03.2023.
//

import Foundation

actor APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }
}

extension APIClient {
    func send<T: Decodable>(_ request: APITarget, for type: T.Type) async throws -> T {
        try await send(request, decode)
    }
    
    func send(_ request: APITarget) async throws -> Void {
        try await send(request) { _ in Void() }
    }
    
    private func send<T>(_ request: APITarget,
                         _ decode: @escaping (Data) async throws -> T) async throws -> T {
        let urlRequest = try await request.makeURLRequest(encoder: encoder)
        let (data, response) = try await send(urlRequest)
        try validate(response: response, data: data)
        return try await decode(data)
    }
    
    private func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
    
    private func decode<T: Decodable>(_ data: Data) async throws -> T {
        try await Task.detached { [decoder] in
            try decoder.decode(T.self, from: data)
        }.value
    }
    
    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        if !(200..<300).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
}
