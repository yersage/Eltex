//
//  ProfileModel.swift
//  Eltex
//
//  Created by Yersage on 23.09.2022.
//

struct ProfileModel: Decodable {
    let roleId: String
    let username: String
    let email: String?
    let permissions: [String]
}
