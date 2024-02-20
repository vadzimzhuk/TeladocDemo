//
//  ApplicationError.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

public enum ApplicationError: Error {
    case none
    case fileNotFound
    case dataCorrupted
    case genericError(Error)
    case unexpectedBehaviour
    case tokenExpired
}

extension ApplicationError {
    var message: String {
        switch self {
            case .fileNotFound:
                return "fileNotFound"
            case .dataCorrupted:
                return "dataCorrupted"
            case .genericError(let error):
                return error.localizedDescription
            default:
                return "unknown"
        }
    }
}
