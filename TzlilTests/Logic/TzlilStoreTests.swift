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
        mockService = MockMusicService()
        mockPlayer = MockAudioPlayer()
        store = TzlilStore(musicService: mockService, audioPlayer: mockPlayer)
        cancellables = []
        
        // איפוס המועדפים לפני כל טסט כדי להתחיל נקי
        UserDefaults.standard.removeObject(forKey: "favorites")
    }
    
    override func tearDown() {
        store = nil
        mockService = nil
        mockPlayer = nil
        cancellables = nil
        super.tearDown()
    }
    
    // בדיקה 1: טעינת שירים רגילה
    func testLoadSongs_Success() {
        // עדכון: הוספת primaryGenreName לבנאי
        let expectedSong = Song(id: 1, trackName: "Test", artistName: "Artist", previewUrl: "url", artworkUrl100: "img", primaryGenreName: "Pop")
        mockService.resultToReturn = .success([expectedSong])
        
        let expectation = XCTestExpectation(description: "Songs loaded")
        
        store.$state
            .dropFirst()
            .sink { state in
                if !state.isLoading && !state.songs.isEmpty {
                    XCTAssertEqual(state.songs.first?.trackName, "Test")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        store.dispatch(.loadSongs(searchTerm: "Anything"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    // בדיקה 2: מועדפים
    func testFavorites_Toggle() {
        let song = Song(id: 1, trackName: "Fav", artistName: "Me", previewUrl: "", artworkUrl100: "", primaryGenreName: "Rock")
        
        store.dispatch(.toggleFavorite(song))
        XCTAssertTrue(store.state.isFavorite(song))
        
        store.dispatch(.toggleFavorite(song))
        XCTAssertFalse(store.state.isFavorite(song))
    }
    
    // בדיקה 3: נגן
    func testPlaySong_TriggersAudioPlayer() {
        let song = Song(id: 1, trackName: "Song", artistName: "Artist", previewUrl: "http://test.com", artworkUrl100: "", primaryGenreName: "Jazz")
        
        store.dispatch(.play(song))
        
        XCTAssertTrue(store.state.isPlaying)
        XCTAssertEqual(store.state.currentSong?.id, song.id)
        XCTAssertTrue(mockPlayer.playCalled)
    }
    
    // בדיקה 4: עדכון זמן
    func testTimeUpdate_UpdatesState() {
        mockPlayer.simulateTimeUpdate(seconds: 10.0)
        XCTAssertEqual(store.state.currentTime, 10.0)
    }
    
    // --- בדיקה חדשה: לוגיקת ה-AI ---
    
    func testSmartRecommendations_SortsByGenre() {
        // Arrange:
        // 1. נגדיר שהמשתמש אוהב "Rock" (נוסיף למועדפים)
        let favoriteSong = Song(id: 100, trackName: "Rock Hit", artistName: "Star", previewUrl: "", artworkUrl100: "", primaryGenreName: "Rock")
        store.dispatch(.toggleFavorite(favoriteSong))
        
        // 2. נכין תשובה מהשרת שמכילה שיר פופ ושיר רוק (בסדר הפוך)
        let popSong = Song(id: 1, trackName: "Pop Song", artistName: "A", previewUrl: "", artworkUrl100: "", primaryGenreName: "Pop")
        let rockSong = Song(id: 2, trackName: "Rock Song", artistName: "B", previewUrl: "", artworkUrl100: "", primaryGenreName: "Rock")
        
        // השרת מחזיר קודם את הפופ, ואז את הרוק
        mockService.resultToReturn = .success([popSong, rockSong])
        
        let expectation = XCTestExpectation(description: "AI Sorting applied")
        
        // Act: מבצעים חיפוש
        store.dispatch(.loadSongs(searchTerm: "Mix"))
        
        // Assert: בודקים את התוצאה
        store.$state
            .dropFirst()
            .sink { state in
                if !state.isLoading && !state.songs.isEmpty {
                    
                    // בדיקה א: האם המערכת זיהתה שרוק הוא הז'אנר המומלץ?
                    XCTAssertEqual(state.recommendedGenre, "Rock")
                    
                    // בדיקה ב: האם המיון עבד? שיר הרוק צריך להיות ראשון, למרות שהגיע שני מהשרת
                    XCTAssertEqual(state.songs.first?.trackName, "Rock Song")
                    XCTAssertEqual(state.songs.last?.trackName, "Pop Song")
                    
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
}
