//
//  API.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 20.06.23.
//

import Foundation
    // swiftlint:disable all
public enum API {
//https://itunes.apple.com/search?term=thebeatles&amp;media=music&amp;entity=album&amp;attribute=artistTerm
    enum ITunes {}
}

extension API.ITunes {
    static var baseUrl: URL = URL(string: "https://itunes.apple.com/")!

    enum Search {
        static var baseUrl: URL = API.ITunes.baseUrl.appending(path: "search")

        struct Request: ApiRequestProtocol {
            struct Parameters {
                var term: String
                var media: String?
                var entity: String?
                var attribute: String?
                var country: String?

                var asDict: [String: String] {
                    var dictionary = ["term": term]
                    if let media { dictionary["media"] = media }
                    if let entity { dictionary["entity"] = entity }
                    if let attribute { dictionary["attribute"] = attribute }
                    if let country { dictionary["country"] = country }

                    return dictionary
                }
            }

            var isAuthorized: Bool?

            typealias SuccessType = SearchResult

            var url: URL {
                let queryItems = parameters.asDict.map { key, value in
                    URLQueryItem(name: key, value: value)
                }
                return Search.baseUrl.appending(queryItems: queryItems)
            }

            var parameters: Parameters

            var method: HTTPMethod? = .post

            var body: Data? {
                let params = parameters.asDict

                return try? JSONEncoder().encode(params)
            }

            var timeout: TimeInterval?

            var cachePolicy: URLRequest.CachePolicy?

            static var testResponseFileName: String = "Login_Response_Success"

            init(parameters: Parameters) {
                self.parameters = parameters
            }
        }

        struct SearchResult: Codable {
            let resultCount: Int
            let results: [Item]
        }

        struct Item: Codable {
            let collectionName: String
            let artworkUrl100: String
        }
    }
}
