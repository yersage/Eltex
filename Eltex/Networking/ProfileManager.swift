//
//  ProfileManager.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

class ProfileManager: NSObject {
    func load(token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://smart.eltex-co.ru:8273/api/v1/user")!,
                                 timeoutInterval: Double.infinity)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
                
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data,
               let model = try? JSONDecoder().decode(ProfileModel.self,
                                                     from: data) {
                completion(.success(model))
            }
        }.resume()
    }
}

extension ProfileManager: URLSessionTaskDelegate {
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
