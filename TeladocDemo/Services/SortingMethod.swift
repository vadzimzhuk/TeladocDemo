//
//  SortingMethod.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

enum SortingMethod: CaseIterable {
    case wordFrequency, wordLength

    var sorter: ((word: String, number: Int), (word: String, number: Int)) -> Bool {
        switch self {
            case .wordFrequency:
                return { tag1, tag2 in
                    tag1.number > tag2.number
                }
            case .wordLength:
                return { tag1, tag2 in
                    tag1.word.count > tag2.word.count
                }
        }
    }

    /// Localization is currently not implemented
    var localizedName: String {
        switch self {
            case .wordFrequency:
                return "Word count"
            case .wordLength:
                return "Word length"
        }
    }
}
