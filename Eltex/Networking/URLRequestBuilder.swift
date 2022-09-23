//
//  LoadManager.swift
//  Eltex
//
//  Created by Yersage on 23.09.2022.
//

import Foundation

protocol NetworkTarget {
    var httpMethod: String { get }
    var authorizationHeader: String { get }
    var urlString: String { get }
    var parameters: [[String: Any]]? { get }
}

struct URLRequestBuilder {
    
    private let target: NetworkTarget
    
    init(target: NetworkTarget) {
        self.target = target
    }
    
    var request: URLRequest {
        return getURLRequest(from: target)
    }
    
    private func getURLRequest(from target: NetworkTarget) -> URLRequest {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var postData: Data?
        
        if let parameters = target.parameters {
            var body = ""
            for param in parameters {
                if param["disabled"] == nil {
                    let paramName = param["key"]!
                    body += "--\(boundary)\r\n"
                    body += "Content-Disposition:form-data; name=\"\(paramName)\""
                    if param["contentType"] != nil {
                        body += "\r\nContent-Type: \(param["contentType"] as! String)"
                    }
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                    
                }
            }
            body += "--\(boundary)--\r\n";
            postData = body.data(using: .utf8)
        }
        
        var request = URLRequest(url: URL(string: target.urlString)!,
                                 timeoutInterval: Double.infinity)
        request.addValue(target.authorizationHeader,
                         forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = target.httpMethod
        request.httpBody = postData
        
        return request
    }
}
