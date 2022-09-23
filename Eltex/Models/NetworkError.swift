//
//  NetworkError.swift
//  Eltex
//
//  Created by Yersage on 24.09.2022.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case invalidData
    case badURL
    case jsonEncodingFailure
    case jsonParsingFailure(objAsString: String, httpStatus: Int, path: String?)
    case custom(message: String)
    case badRequestWithResponse(responseData: Data)

    var errorDescription: String? {
        switch self {

        case .invalidResponse: return "Невалидный ответ от сервера"

        case .invalidData: return "Полученные данные неверны"

        case .badURL: return "Не могу создать ссылку"

        case .jsonEncodingFailure: return "Не удалось создать json из модели запроса"

        case .jsonParsingFailure(let str, let status, let path): return "Не смог распарсить данные от сервера \n respAsString \(str)\n httpStatus \(status)\n path \(String(describing: path))"

        case .custom(let message): return message

        case .badRequestWithResponse:
            return "400: Bad request"
        }

    }
}
