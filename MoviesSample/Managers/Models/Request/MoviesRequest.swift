//
//  MoviesRequest.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation

class MoviesRequest: Codable {
    var apikey = APIKey.key
    var type = Configs.typeRequest
    var textSearch: String?
    var page: Int
    enum CodingKeys: String, CodingKey {
        case apikey, type, textSearch = "s", page
    }
    
    init(textSearch: String?, page: Int) {
        self.textSearch = textSearch
        self.page = page
    }
}
extension MoviesRequest {
    struct Configs {
        static let typeRequest = "movie"
    }
}
