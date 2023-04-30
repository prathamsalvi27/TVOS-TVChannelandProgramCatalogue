//
//  NetworkResponse.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import Foundation

// Response
struct NetworkResponse {
    let statusCode: Int
    let data: Data?
    let error: NetworkError?
}

enum NetworkError: Error {
    case noInternetNetwork(String)
    case serverResponseFailed(String)
    case somethingWentWrong(String)
}
