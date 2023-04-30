//
//  NetworkRequest.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import Foundation
// Request
struct NetworkRequest {
    let url: String
    let headers: [String: String]
    let httpRequest: HTTPRequest
    let paramenter: [String: Any]? = nil
    let queryParams: [String: String]? = nil
}

enum HTTPRequest: String {
    case get = "GET"
    case post = "POST"
}
