//
//  String.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

