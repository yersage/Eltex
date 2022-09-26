//
//  NetworkError.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case server
    case decode
    case unknown
    case badResponse
    case custom(message: String)
    
    var description: String {
        switch self {
        case .badRequest:
            return "Неправильный URL"
        case .unauthorized:
            return "Неправильно введенные имя или пароль"
        case .server:
            return "Упс! Проблемы с сервером."
        case .decode:
            return "Неправильные данные от сервера."
        case .unknown:
            return "Неизвестная ошибка"
        case .badResponse:
            return "Не удалось обработать ответ сервера."
        case .custom(let message):
            return message
        }
    }
}
