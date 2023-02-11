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
    var searchText: String?
    enum CodingKeys: String, CodingKey {
        case apikey, type, searchText = "s"
    }
    
    init(searchText: String?) {
        self.searchText = searchText
    }
}
extension MoviesRequest {
    struct Configs {
        static let typeRequest = "movie"
    }
}
