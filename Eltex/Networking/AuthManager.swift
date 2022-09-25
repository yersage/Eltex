//
//  AuthManager.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

class AuthManager: NSObject {
    func load(username: String,
              password: String,
              completion: @escaping (TokenModel?, String?) -> Void) {
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        
        let request = getURLRequest(username: username,
                                    password: password)
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(nil, error.localizedDescription)
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, "Не удалось обработать ответ сервера.")
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if statusCode != 200 {
                completion(nil, HTTPResponse(rawValue: statusCode)?.rawValue)
            }
            
            if let data = data,
               let model = try? JSONDecoder().decode(TokenModel.self,
                                                     from: data) {
                completion(model, nil)
            } else {
                completion(nil, HTTPResponse.couldntDecode.rawValue)
            }
        }.resume()
    }
    
    func getURLRequest(username: String,
                       password: String) -> URLRequest {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var postData: Data?
        
        let parameters: [[String : Any]] = [
            [
                "key": "grant_type",
                "value": "password"
            ],
            [
                "key": "username",
                "value": username
            ],
            [
                "key": "password",
                "value": password
            ]
        ]
        
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

extension AuthManager: URLSessionTaskDelegate {
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
