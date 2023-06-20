//
//  NetworkService.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 20.06.23.
//

import Foundation
import Combine

protocol NetworkService {
    func getAlbums(for author: String) -> AnyPublisher<API.ITunes.Search.Request.SuccessType, ApplicationError>
}

class ITunesNetworkService: NetworkService {
    private var requestManager: RequestManager = RequestManager()

    func getAlbums(for author: String) -> AnyPublisher<API.ITunes.Search.Request.SuccessType, ApplicationError> {
        let request = API.ITunes.Search.Request(parameters: .init(term: author, entity: "album", country: "us"))
        return requestManager.make(requestOptions: request)
    }
}
