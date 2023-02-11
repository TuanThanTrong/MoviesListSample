//
//  Constants.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
struct APIKey {
    static let key = "b9bd48a6"
    struct APIUrl {
        static let baseURL = "http://www.omdbapi.com/"
    }
    
    struct MoviesUrl {
        static func search(query: String) -> String {
            return "?\(query)"
        }
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
