//
//  ApiRequest.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 20.06.23.
//

import Foundation

final class ApiRequest {
    var isAuthorized: Bool
    var url: URL
    var cachePolicy: URLRequest.CachePolicy
    var timeout: TimeInterval
    var body: Data?
    var httpMethod: String

    var urlRequest: URLRequest {
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = httpMethod
        request.httpBody = body
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        return request
    }

    init(options: ApiRequestOptionsProtocol) {
        self.url = options.url
        self.cachePolicy = options.cachePolicy ?? .useProtocolCachePolicy
        self.timeout = options.timeout ?? 60.0
        self.body = options.body
        self.httpMethod = options.method?.rawValue ?? HTTPMethod.get.rawValue
        self.isAuthorized = options.isAuthorized ?? false
    }
}

    // MARK: - ApiRequestOptionsProtocol
protocol ApiRequestOptionsProtocol {
    var url: URL { get }
    var method: HTTPMethod? { get }
    var body: Data? { get }
    var timeout: TimeInterval? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var isAuthorized: Bool? { get }
}

    // MARK: - ApiRequestProtocol
protocol ApiRequestProtocol: ApiRequestOptionsProtocol, TestRequestOptionsProtocol {
    associatedtype SuccessType: Codable
}

extension ApiRequestProtocol {
    typealias ResponseType = SuccessType
}

    // MARK: - ResponseMessage
struct ResponseMessage: Codable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

    // MARK: - Response
struct Response<T: Codable>: Codable {
    let status: ApiResponseStatus
    let messages: [ResponseMessage]?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case status
        case messages
        case data
    }
}

protocol TestRequestOptionsProtocol {
    static var testResponseFileName: String { get }
}
