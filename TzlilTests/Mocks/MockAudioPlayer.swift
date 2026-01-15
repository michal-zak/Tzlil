//
//  MockAudioPlayer.swift
//  Tzlil
//
//  Created by user945522 on 1/15/26.
//

import Foundation
@testable import Tzlil

class MockAudioPlayer: AudioPlayerProtocol {
    // משתנים לבדיקה: האם הפונקציות נקראו?
    var playCalled = false
    var lastPlayedUrl: URL?
    var toggleCalled = false
    
    // מימוש הפרוטוקול
    var didFinishPlaying: (() -> Void)?
    var onTimeUpdate: ((Double) -> Void)?
    
    func play(url: URL) {
        playCalled = true
        lastPlayedUrl = url
    }
    
    func togglePlayPause(isPlaying: Bool) {
        toggleCalled = true
    }
    
    // פונקציית עזר לטסטים: סימולציה של התקדמות זמן
    func simulateTimeUpdate(seconds: Double) {
        onTimeUpdate?(seconds)
    }
    
    // פונקציית עזר לטסטים: סימולציה של סיום שיר
    func simulateFinishPlaying() {
        didFinishPlaying?()
    }
}
