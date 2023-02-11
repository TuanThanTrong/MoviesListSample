//
//  APIService.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
import Alamofire
import SwiftyJSON

struct APIService {
    static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion: @escaping ((AFDataResponse<T>) -> Void)) -> Void {
        AF.request(route)
            .responseDecodable { (response) in
            completion(response)
        }
    }
    
    static func performRequestData<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), decodingType: T.Type, completion: @escaping (Decodable?, PSError?) -> Void) {
        AF.request(route).responseData { (response) in
            switch response.result {
                case .success(let value):
                    //print("JSON: \(JSON(value))")
                    if response.response?.statusCode != 200 {
                        let parseError = parseErrorData(errorData: value)
                        completion(nil, parseError)
                    } else {
                        do {
                            let user = try JSONDecoder().decode(decodingType, from: value)
                            let parseError = parseErrorData(errorData: value)
                            completion(user, parseError)
                        }catch {
                            print(error)
                            let parseError = parseErrorData(errorData: value)
                            completion(nil, parseError)
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    let errorMessage = AppString.ErrorDefine.networkingError
                    let error = PSError(data: nil, code: nil, message: errorMessage)
                    completion(nil, error)
            }
        }
    }
    
    static func performRequestJson(route:APIRouter, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(route)
            .responseJSON { response in
            completion(response)
        }
    }
    
    static func parseErrorData(errorData: Data) -> PSError {
        let jsonData = JSON(errorData)
        print(jsonData)
        let message = jsonData["message"].string ?? AppString.ErrorDefine.parseDataError
        let code = jsonData["code"].string
        return PSError(data: nil, code: code, message: message)
    }
    
}

struct PSError {
    var data: Any?
    var code: String?
    var message: String
    
    init(data: Any?, code: String?, message: String) {
        self.data = data
        self.code = code
        self.message = message
    }
}
