//
//  MockMusicService.swift
//  Tzlil
//
//  Created by user945522 on 1/15/26.
//

import Foundation
import Combine
@testable import Tzlil // החליפי בשם הפרויקט שלך במידה והוא שונה

class MockMusicService: MusicServiceProtocol {
    var resultToReturn: Result<[Song], Error>?
    
    func searchSongs(term: String) -> AnyPublisher<[Song], Error> {
        if let result = resultToReturn {
            return result.publisher.eraseToAnyPublisher()
        }
        // ברירת מחדל: מחזיר רשימה ריקה כדי שהטסט לא יקרוס
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
