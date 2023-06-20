//
//  RequestManager.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 20.06.23.
//

import Foundation
import Combine

class RequestManager {

//    init() {
//    }

    private func testOutputFor<T: ApiRequestProtocol>(requestOptions: T) -> URLSession.DataTaskPublisher.Output {
        let response: URLResponse = HTTPURLResponse(url: requestOptions.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data: Data

        do {
            let filePath = Bundle.main.url(forResource: T.testResponseFileName, withExtension: "json")!
            data = try Data(contentsOf: filePath)
        } catch {
//            print("URL not handled: \(String(describing: requestOptions.url.absoluteString))")
            data = Data()
        }

        return (data: data, response: response)
    }

    private func makeRequest<T: ApiRequestProtocol>(requestOptions: T) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        let request = ApiRequest(options: requestOptions).urlRequest

//        if isTestEnvironment {
//            let output = testOutputFor(requestOptions: requestOptions)
//
//            return Just(output)
//                .mapError { $0 }
//                .eraseToAnyPublisher()
//        } else {
            return URLSession.shared.dataTaskPublisher(for: request)
                .eraseToAnyPublisher()
//        }
    }

    func make<T: ApiRequestProtocol>(requestOptions: T) -> AnyPublisher<T.SuccessType, ApplicationError> {
        makeRequest(requestOptions: requestOptions)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse,
                   let statusCode = HTTPStatusCode(rawValue: response.statusCode) {
                    switch statusCode.responseType {
                        case .success:
//                            Logger.shared.logInfo(String(data: data, encoding: .utf8))
                            return data
                        default:
                            switch statusCode {
                                case .unauthorized:
                                    throw ApplicationError.tokenExpired
                                default:
//                                    throw ApplicationError.httpError(statusCode)
                                    break
                            }
                    }
                }

//                Logger.shared.logInfo(String(data: data, encoding: .utf8))
                return data
            }
            .decode(type: T.ResponseType.self, decoder: JSONDecoder())
//            .tryMap { response in
//                let status = response.status
//
//                switch status {
//                    case .success:
//                        guard let data = response.data else { throw ApplicationError.unexpectedBehaviour }
//                        return data
//                    case .failed:
//                        throw ApplicationError.unexpectedBehaviour
//                    case .reloginNeeded:
//                        throw ApplicationError.tokenExpired
//                }
//            }
            .mapError { error in
//                error.log()
                if let error = error as? ApplicationError {
                    return error
                } else {
                    return ApplicationError.genericError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
