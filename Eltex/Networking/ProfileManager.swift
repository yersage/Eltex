//
//  ProfileManager.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

class ProfileManager: NSObject {
    func getProfileInfo(token: String,
              completion: @escaping (Result<ProfileModel, NetworkError>) -> Void) {
        
        guard let url = URL(string: "https://smart.eltex-co.ru:8273/api/v1/user") else {
            completion(.failure(.badRequest))
            return
        }
        
        var request = URLRequest(url: url,
                                 timeoutInterval: Double.infinity)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)
                
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                completion(.failure(.custom(message: error.localizedDescription)))
            } else if let error = self?.handleHTTPResponse(response as? HTTPURLResponse) {
                completion(.failure(error))
            }
            
            if let data = data,
               let model = try? JSONDecoder().decode(ProfileModel.self,
                                                     from: data) {
                completion(.success(model))
            } else {
                completion(.failure(.decode))
            }
        }.resume()
    }
    
    private func handleHTTPResponse(_ response: HTTPURLResponse?) -> NetworkError? {
        
        guard let response = response else {
            return NetworkError.badResponse
        }
        
        switch response.statusCode {
        case 200:
            return nil
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 500:
            return .server
        default:
            return .unknown
        }
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
