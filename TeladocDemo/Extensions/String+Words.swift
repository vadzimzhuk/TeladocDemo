//
//  String+Words.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

extension String {
    func words() -> [String] {
        var words: [String] = []

        let nsRange = NSRange(location: 0, length: self.utf16.count)
        guard let range = Range(nsRange, in: self) else { return words }

        self.enumerateSubstrings(in: range, options: .byWords) { substring, _, _, _ in
            guard let substring else { return }
            words.append(substring)
        }

        return words
    }
}
