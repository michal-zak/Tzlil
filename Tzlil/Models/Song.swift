//
//  Song.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation

struct Song: Identifiable, Codable, Equatable {
    let id: Int
    let trackName: String
    let artistName: String
    let previewUrl: String
    let artworkUrl100: String

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName, artistName, previewUrl, artworkUrl100
    }
}

struct ITunesResponse: Codable {
    let results: [Song]
}
