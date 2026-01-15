//
//  TzlilStoreTests.swift
//  Tzlil
//
//  Created by user945522 on 1/15/26.
//

import XCTest
import Combine
@testable import Tzlil

class TzlilStoreTests: XCTestCase {
    
    var store: TzlilStore!
    var mockService: MockMusicService!
    var mockPlayer: MockAudioPlayer!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        // 1. אתחול ה-Mocks
        mockService = MockMusicService()
        mockPlayer = MockAudioPlayer()
        
        // 2. הזרקת ה-Mocks לתוך ה-Store
        store = TzlilStore(musicService: mockService, audioPlayer: mockPlayer)
        cancellables = []
    }
    
    override func tearDown() {
        store = nil
        mockService = nil
        mockPlayer = nil
        cancellables = nil
        super.tearDown()
    }
    
    // בדיקה 1: האם חיפוש טוען שירים ל-State בהצלחה?
    func testLoadSongs_Success() {
        // Arrange
        let expectedSong = Song(id: 1, trackName: "Test", artistName: "Artist", previewUrl: "url", artworkUrl100: "img")
        mockService.resultToReturn = .success([expectedSong])
        
        let expectation = XCTestExpectation(description: "Songs loaded")
        
        store.$state
            .dropFirst()
            .sink { state in
                if !state.isLoading && !state.songs.isEmpty {
                    // Assert
                    XCTAssertEqual(state.songs.first?.trackName, "Test")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        // Act
        store.dispatch(.loadSongs(searchTerm: "Anything"))
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // בדיקה 2: הוספה והסרה ממועדפים
    func testFavorites_Toggle() {
        let song = Song(id: 1, trackName: "Fav", artistName: "Me", previewUrl: "", artworkUrl100: "")
        
        // Act 1: הוספה
        store.dispatch(.toggleFavorite(song))
        XCTAssertTrue(store.state.isFavorite(song))
        
        // Act 2: הסרה
        store.dispatch(.toggleFavorite(song))
        XCTAssertFalse(store.state.isFavorite(song))
    }
    
    // בדיקה 3: האם לחיצה על Play מפעילה את הנגן?
    func testPlaySong_TriggersAudioPlayer() {
        let song = Song(id: 1, trackName: "Song", artistName: "Artist", previewUrl: "http://test.com", artworkUrl100: "")
        
        // Act
        store.dispatch(.play(song))
        
        // Assert
        XCTAssertTrue(store.state.isPlaying)
        XCTAssertEqual(store.state.currentSong?.id, song.id)
        XCTAssertTrue(mockPlayer.playCalled) // האם ה-Mock דיווח שקראו לו?
        XCTAssertEqual(mockPlayer.lastPlayedUrl?.absoluteString, "http://test.com")
    }
    
    // בדיקה 4: האם עדכון זמן מהנגן מעדכן את ה-State?
    func testTimeUpdate_UpdatesState() {
        // Act - נדמה שהנגן שידר שהגענו לשנייה ה-10
        mockPlayer.simulateTimeUpdate(seconds: 10.0)
        
        // Assert
        XCTAssertEqual(store.state.currentTime, 10.0)
    }
}
