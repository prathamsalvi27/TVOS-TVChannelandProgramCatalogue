//
//  NetworkService.swift
//  Vmedia
//
//  Created by Prathamesh Salvi on 28/04/23.
//

import Foundation

// Simple NETWORK Library for API Calls
// Only Get and Post Request are Handled as Of now
final class NetworkService {
    
    static let shared: NetworkService = NetworkService()
    
    // Default Response Object for Unknown Error
    let errorResponse: NetworkResponse = NetworkResponse(statusCode: 600, data: nil, error: NetworkError.somethingWentWrong("Something Went Wrong"))
    
    var urlSessionDataTask: URLSessionDataTask?
    private init() {}
    
    // Function That make HTTP Request
    func startRequest(request: NetworkRequest, completion: @escaping (NetworkResponse) -> Void) {
        
        guard let url = URL(string: request.url) else {
            return completion(errorResponse)
        }
        // MAKE URL Request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpRequest.rawValue
        for field in request.headers {
            urlRequest.setValue(field.key, forHTTPHeaderField: field.value)
        }
        // Query Parameters
        if let queryParams = request.queryParams {
            var queryItemArr: [URLQueryItem] = []
            for item in queryParams {
                queryItemArr.append(URLQueryItem(name: item.key, value: item.value))
            }
            urlRequest.url?.append(queryItems: queryItemArr)
        }
        
        // HTTP Post Parameters
        if let params = request.paramenter {
            let paramData = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
            urlRequest.httpBody = paramData
        }
        
        // Network Request
        urlSessionDataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            if let dataObj = data {
                let response = NetworkResponse(statusCode: 200, data: dataObj, error: nil)
                DispatchQueue.main.async {
                    completion(response)
                }
            } else {
                DispatchQueue.main.async {
                    completion(self.getErrorObj(errorType: .serverResponseFailed("Server Response Failed")))
                }
            }
        })
        
        urlSessionDataTask?.resume()
    }
    
    // Returns Error Objects Based on Type Of Errors
    private func getErrorObj(errorType: NetworkError) -> NetworkResponse {
        switch errorType {
        case .noInternetNetwork(let message):
            // No Internet currently is not implemented
            return NetworkResponse(statusCode: 600, data: nil, error: NetworkError.somethingWentWrong(message))
        case .serverResponseFailed(let message):
            return NetworkResponse(statusCode: 600, data: nil, error: NetworkError.somethingWentWrong(message))
        case .somethingWentWrong(let message):
            return NetworkResponse(statusCode: 600, data: nil, error: NetworkError.somethingWentWrong(message))
        }
    }
}
