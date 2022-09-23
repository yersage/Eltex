//
//  AuthManager.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

class AuthManager: NSObject {
    func load(completion: @escaping (Result<TokenModel, Error>) -> Void) {
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
        
        let request = URLRequestBuilder(target: AuthTarget()).request
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data,
               let model = try? JSONDecoder().decode(TokenModel.self,
                                                     from: data) {
                completion(.success(model))
            }
            
            print(response)
        }.resume()
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
