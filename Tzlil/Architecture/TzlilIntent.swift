//
//  TzlilIntent.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation

enum TzlilIntent {
    case loadSongs(searchTerm: String)
    case play(Song)
    case togglePlayPause
    case audioFinished
    case updateTime(Double) // עדכון זמן
}
