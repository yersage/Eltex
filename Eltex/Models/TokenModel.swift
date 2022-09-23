//
//  TokenModel.swift
//  Eltex
//
//  Created by Yersage on 23.09.2022.
//

struct TokenModel: Decodable {
    let access_token: String
    let refresh_token: String
    let scope: String
    let token_type: String
    let expires_in: Int
}
