//
//  StorageService.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

protocol StorageService {
    func getSourceText() async throws -> String
}

final class FileStorage {
    private var fileName: String
    private let fileNameExtension = ".txt"

    init(fileName: String) {
        self.fileName = fileName
    }
}

extension FileStorage: StorageService {
    func getSourceText() async throws -> String {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileNameExtension) else {
            throw ApplicationError.fileNotFound
        }
        let text = try String(contentsOf: url, encoding: .utf8)
        return text
    }
}
