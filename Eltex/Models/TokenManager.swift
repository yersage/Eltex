//
//  TokenManager.swift
//  Eltex
//
//  Created by Yersage on 23.09.2022.
//

import Foundation

class TokenManager: NSObject {
    
    func load(completion: @escaping ((Data?, URLResponse?, Error?)) -> Void) {
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        
        do {
            guard let request = try getURLRequest() else {
                completion((nil, nil, nil))
                return
            }
            urlSession.dataTask(with: request) { data, response, error in
                completion((data, response, error))
            }.resume()
        }
        catch {
            completion((nil, nil, error))
        }
    }
    
    func getURLRequest() throws -> URLRequest? {
        let parameters = [
            [
                "key": "grant_type",
                "value": "password"
            ],
            [
                "key": "username",
                "value": "yersage"
            ],
            [
                "key": "password",
                "value": "yersage"
            ]] as [[String : Any]]
        
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
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://smart.eltex-co.ru:8273/api/v1/oauth/token")!,
                                 timeoutInterval: Double.infinity)
        request.addValue("Basic aW9zLWNsaWVudDpwYXNzd29yZA==",
                         forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        return request
    }
}

extension TokenManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}

//if paramType == "text" {
//    let paramValue = param["value"] as! String
//    body += "\r\n\r\n\(paramValue)\r\n"
//} else {
//    let paramSrc = param["src"] as! String
//    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
//    let fileContent = String(data: fileData, encoding: .utf8)!
//    body += "; filename=\"\(paramSrc)\"\r\n"
//    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//}
