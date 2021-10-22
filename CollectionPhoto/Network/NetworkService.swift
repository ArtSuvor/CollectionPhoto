//
//  NetworkService.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import Foundation

class NetworkService {
    func request(searchTerm: String, handler: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        let task = createDataTask(from: request, handler: handler)
        task.resume()
    }
    
    private func prepareHeader() -> [String: String]? {
        var header = [String: String]()
        header["Authorization"] = "Client-ID 7PNbpeUaJNgVJSL0Yz8uo9b3MHgwNNMNdScZoZMSeD8"
        return header
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map {URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func prepareParameters(searchTerm: String) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = "1"
        parameters["per_page"] = "30"
        return parameters
    }
    
    private func createDataTask(from request: URLRequest, handler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                handler(data, error)
            }
        }
    }
}
