//
//  SongRowView.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import SwiftUI

struct SongRowView: View {
    let song: Song
    let isPlaying: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(song.trackName)
                    .font(.body)
                    .lineLimit(1)
                Text(song.artistName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isPlaying {
                Image(systemName: "waveform")
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle()) // לחיצה על כל השורה
    }
}
