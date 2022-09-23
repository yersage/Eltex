//
//  AuthTarget.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

protocol NetworkTarget {
    var httpMethod: String { get }
    var authorizationHeader: String { get }
    var urlString: String { get }
    var parameters: [[String: Any]]? { get }
}

struct AuthTarget: NetworkTarget {
    var httpMethod: String = "POST"
    var authorizationHeader: String = "Basic aW9zLWNsaWVudDpwYXNzd29yZA=="
    var urlString: String = "https://smart.eltex-co.ru:8273/api/v1/oauth/token"
    var parameters: [[String : Any]]? = [
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
        ]
    ] as [[String : Any]]
}
