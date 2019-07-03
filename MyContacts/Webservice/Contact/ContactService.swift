//
//  ContactService.swift
//  MyContacts
//
//  Created by dreams on 6/20/19.
//  Copyright © 2019 Dreams. All rights reserved.
//

import UIKit
import Alamofire

protocol ContactService: BaseService {
    func webServiceGetError(_ error: NetworkError)
    func webServiceGetResponse(data: [Contact])
}

extension ContactService {
    func fetchContacts() {
        
        let headers: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        let url = "http://my-json-server.typicode.com/rgiurea/contacts/tree/master/all"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            let (parsedResult, parsedError) = self.parse(response)
            if let error = parsedError {
                self.webServiceGetError(error)
            } else if let parsedResult = parsedResult {
                guard let _ = parsedResult[AppErrorInfo.ErrorKey] else {
                    var contacts: [Contact] = []
                    if let array = parsedResult["data"] as? [[String : Any]] {
                        contacts = array.map { Contact(dict: $0) }
                    }
                    self.webServiceGetResponse(data: contacts)
                    return
                }
                guard let errorDescription = parsedResult[AppErrorInfo.ErrorDescriptionKey] as? String else {
                    self.webServiceGetError(NetworkError.serverError)
                    return
                }
                self.webServiceGetError(NetworkError.messageError(errorDescription))
            }
        }
    }
}
