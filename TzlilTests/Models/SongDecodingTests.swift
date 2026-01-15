//
//  SongDecodingTests.swift
//  Tzlil
//
//  Created by user945522 on 1/15/26.
//

import XCTest
@testable import Tzlil

class SongDecodingTests: XCTestCase {

    func testSongDecoding() throws {
        // Arrange: יצירת JSON לדוגמה כמו ש-iTunes מחזיר
        let json = """
        {
            "trackId": 12345,
            "trackName": "Hello",
            "artistName": "Adele",
            "previewUrl": "http://audio.com",
            "artworkUrl100": "http://image.com"
        }
        """.data(using: .utf8)!
        
        // Act: ניסיון לפענח
        let song = try JSONDecoder().decode(Song.self, from: json)
        
        // Assert: וידוא שהשדות מופו נכון
        XCTAssertEqual(song.id, 12345)
        XCTAssertEqual(song.trackName, "Hello")
        XCTAssertEqual(song.artistName, "Adele")
    }
}
