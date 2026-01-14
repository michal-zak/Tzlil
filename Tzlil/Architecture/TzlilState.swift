//
//  TzlilState.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation

struct TzlilState {
    var songs: [Song] = []
    var favoriteSongs: [Song] = [] // רשימת המועדפים
    var currentSong: Song?
    var isPlaying: Bool = false
    var isLoading: Bool = false
    var error: String?
    
    // נתונים לנגן
    var currentTime: Double = 0.0
    var duration: Double = 30.0 // אורך ה-Preview בדרך כלל
    
    // בדיקה מהירה אם שיר הוא מועדף
    func isFavorite(_ song: Song) -> Bool {
        return favoriteSongs.contains(where: { $0.id == song.id })
    }
}
