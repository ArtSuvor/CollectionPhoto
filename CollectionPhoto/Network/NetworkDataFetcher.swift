//
//  NetworkDataFetch.swift
//  CollectionPhoto
//
//  Created by Art on 23.10.2021.
//

import Foundation

class NetworkDataFetcher {
    let network = NetworkService()
    
    func fetchImage(searchTerm: String, handler: @escaping (SearchResults?) -> ()) {
        network.request(searchTerm: searchTerm) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                handler(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            handler(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError{
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
