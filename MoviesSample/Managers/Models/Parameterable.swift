//
//  Parameterable.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation

protocol Parameterable {
    func parameters<T: Codable>(object: T) -> Data?
    func query<T: Codable>(object: T) -> String?
}

extension Parameterable {
    func parameters<T: Codable>(object: T) -> Data? {
        return try? JSONEncoder().encode(object)
    }
    func query<T: Codable>(object: T) -> String? {
        guard let dataEncode = parameters(object: object), let jsonString = String(data: dataEncode, encoding: .utf8), let queryString = jsonString.convertToDictionary()?.queryString else { return nil }
        return queryString
    }
}
extension BaseViewModel: Parameterable {}
