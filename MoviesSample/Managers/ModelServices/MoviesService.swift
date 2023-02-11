//
//  MoviesService.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
import Alamofire

enum MoviesService: APIRouter {
    case getMovies(query: String)
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getMovies:
            return .get
        }
    }
    
    var path: String? {
        switch self {
        case .getMovies(let query):
            return APIKey.MoviesUrl.search(query: query)
            
        }
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    static func getMovieList(query: String, completion: @escaping (MoviesResponse?, PSError?) -> Void) {
        let getMovie: MoviesService = .getMovies(query: query)
        APIService.performRequestData(route: getMovie, decodingType: MoviesResponse.self) { (result,error) in
            if let result = result as? MoviesResponse, let movies = result.movies, !movies.isEmpty {
                completion(result, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
