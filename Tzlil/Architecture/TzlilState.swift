//
//  TzlilState.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation

struct TzlilState {
    var songs: [Song] = []
    var currentSong: Song?
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var error: String?
    var currentTime: Double = 0.0 // הזמן הנוכחי בשניות
    var duration: Double = 30.0   // רוב ה-Preview ב-iTunes הם 30 שניות
    
    // Computed helper (Optional)
    var showMiniPlayer: Bool {
        return currentSong != nil
    }
}
