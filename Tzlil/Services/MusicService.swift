//
//  MusicService.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation
import Combine

protocol MusicServiceProtocol {
    func searchSongs(term: String) -> AnyPublisher<[Song], Error>
}

class MusicService: MusicServiceProtocol {
    func searchSongs(term: String) -> AnyPublisher<[Song], Error> {
        // המרת רווחים ל-Encoding מתאים
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?term=\(encodedTerm)&media=music&limit=25") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ITunesResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
