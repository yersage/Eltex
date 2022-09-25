//
//  NetworkError.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

enum HTTPResponse: Int {
    case ok = 200
    case badRequest = 400
    case unauthorized
    case internalServerError = 500
    case couldntDecode
    
    var rawValue: String {
        switch self {
        case .ok:
            return "Успешно."
        case .badRequest:
            return "Неправильный URL-запрос."
        case .unauthorized:
            return "Неправильно введенные имя или пароль."
        case .internalServerError:
            return "Упс! Что-то пошло не так."
        case .couldntDecode:
            return "Неправильные данные от сервера."
        }
    }
}
