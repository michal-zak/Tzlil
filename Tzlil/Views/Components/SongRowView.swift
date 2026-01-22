//
//  SongRowView.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import SwiftUI

struct SongRowView: View {
    let song: Song
    let isPlaying: Bool
    let isFavorite: Bool
    var isRecommended: Bool = false // פרמטר חדש עם ברירת מחדל
    let onFavoriteToggle: () -> Void
    
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
                HStack(spacing: 4) {
                    Text(song.trackName).font(.body).lineLimit(1)
                    
                    // אם זה שיר מומלץ - נציג אייקון
                    if isRecommended {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
                Text(song.artistName).font(.caption).foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                HapticManager.shared.selection() // 📳 רטט עדין
                onFavoriteToggle()
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .padding(8)
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel(isFavorite ? "הסר ממועדפים" : "הוסף למועדפים")
            .accessibilityHint("לחיצה כפולה תשנה את הסטטוס")
            
            if isPlaying {
                Image(systemName: "waveform").foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(song.trackName), מאת \(song.artistName)")
        .accessibilityAddTraits(isPlaying ? [.isSelected] : [])
    }
}
