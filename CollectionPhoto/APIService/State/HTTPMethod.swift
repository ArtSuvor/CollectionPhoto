//
//  HttpMethod.swift
//  APIService
//
//  Created by Art on 01.03.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
    case options = "OPTIONS"
    case head = "HEAD"
    case trace = "TRACE"
}
