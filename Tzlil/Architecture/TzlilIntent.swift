//
//  TzlilIntent.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import Foundation

enum TzlilIntent {
    case inputChanged(String)          // הקלדה בחיפוש (Live)
    case loadSongs(searchTerm: String) // ביצוע החיפוש
    case play(Song)
    case togglePlayPause
    case audioFinished
    case updateTime(Double)
    case toggleFavorite(Song)          // הוספה/הסרה ממועדפים
}
