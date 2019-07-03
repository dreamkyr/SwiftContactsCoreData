//
//  BaseService.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit
import Alamofire

protocol BaseService: NSObjectProtocol {
    
}

extension BaseService {
    func parse( _ response: DataResponse<Any>) -> ([String: AnyObject]?, NetworkError?) {
        guard let result = response.value else {
            return (response: nil, error: .serverError)
        }
        
        guard let json = result as? [String: AnyObject] else {
            guard let str = result as? [Any] else {
                return (response: nil, error: .serverError)
            }
            return(["data": str as AnyObject], error: nil)
        }
        return(json, error: nil)
    }
}

enum NetworkError: Error, LocalizedError {
    case serverError, messageError(_ message: String), accessTokenError
    
    public var localizedDescription: String {
        switch self {
        case .messageError(let message):
            return message
        default:
            return "Sorry, something went wrong.\nPlease try again later."
        }
    }
}
