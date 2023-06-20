//
//  ApiResponseStatus.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 20.06.23.
//

import Foundation

enum ApiResponseStatus: String, Codable {
    case success
    case failed
    case reloginNeeded
}
