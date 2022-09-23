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

class URLRequestBuilder: NSObject {
    
    private let target: NetworkTarget
    
    init(target: NetworkTarget) {
        self.target = target
    }
    
    var request: URLRequest {
        return getURLRequest(from: target)
    }
    
    private func getURLRequest(from target: NetworkTarget) -> URLRequest {
        
        let httpBody = getHTTPBody(from: target.parameters)
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: target.urlString)!,
                                 timeoutInterval: Double.infinity)
        request.addValue(target.authorizationHeader,
                         forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = target.httpMethod
        request.httpBody = httpBody
        
        return request
    }
    
    private func getHTTPBody(from parameters: [[String: Any]]?) -> Data? {
        
        guard let parameters = parameters else {
            return nil
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
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
        let data = body.data(using: .utf8)
        
        return data
    }
}

extension URLRequestBuilder: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
