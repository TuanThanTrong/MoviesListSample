//
//  APIRouter.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String? { get }
    var parameters: Parameters? { get }
    var headerValue: String? { get }
    var baseUrl: String { get }
}

extension APIRouter {
    var baseUrl: String {
        return  APIKey.APIUrl.baseURL
    }
    
    var headerValue: String? {
        return nil
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlString = baseUrl
        if let path = path {
            urlString = urlString + path
        }
        print(urlString)
        let url = try urlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let headerValue = headerValue {
            urlRequest.setValue(headerValue, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}

protocol APIRouterDownload: URLRequestConvertible {
    var path: String? { get }
    var method: HTTPMethod { get }
}

extension APIRouterDownload {
    var method: HTTPMethod {
        return .get
    }
    func asURLRequest() throws -> URLRequest {
        let pathStr = path ?? ""
        let url = try pathStr.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        return urlRequest
    }
}
