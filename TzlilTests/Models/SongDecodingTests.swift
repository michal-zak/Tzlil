//
//  SongDecodingTests.swift
//  Tzlil
//
//  Created by user945522 on 1/15/26.
//

import XCTest
@testable import Tzlil

class SongDecodingTests: XCTestCase {

    func testSongDecoding_WithGenre() throws {
        // Arrange: JSON עם ז'אנר
        let json = """
        {
            "trackId": 12345,
            "trackName": "Hello",
            "artistName": "Adele",
            "previewUrl": "http://audio.com",
            "artworkUrl100": "http://image.com",
            "primaryGenreName": "Pop"
        }
        """.data(using: .utf8)!
        
        // Act
        let song = try JSONDecoder().decode(Song.self, from: json)
        
        // Assert
        XCTAssertEqual(song.id, 12345)
        XCTAssertEqual(song.trackName, "Hello")
        XCTAssertEqual(song.primaryGenreName, "Pop") // ✅ וידוא שהשדה החדש נקלט
    }
    
    func testSongDecoding_WithoutGenre() throws {
        // Arrange: JSON ללא שדה הז'אנר (כדי לבדוק שה-Optional עובד ולא קורס)
        let json = """
        {
            "trackId": 999,
            "trackName": "Unknown",
            "artistName": "Anon",
            "previewUrl": "http://audio.com",
            "artworkUrl100": "http://image.com"
        }
        """.data(using: .utf8)!
        
        // Act
        let song = try JSONDecoder().decode(Song.self, from: json)
        
        // Assert
        XCTAssertEqual(song.id, 999)
        XCTAssertNil(song.primaryGenreName) // ✅ מוודאים שזה nil ולא קרס
    }
}
