//
//  MiniPlayerView.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import SwiftUI

struct MiniPlayerView: View {
    let song: Song
    let isPlaying: Bool
    let currentTime: Double
    let duration: Double
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // חלק עליון: תמונה, טקסט וכפתור
            HStack {
                AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 44, height: 44)
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.trackName)
                        .font(.headline)
                        .fontDesign(.rounded)
                        .lineLimit(1)
                    
                    Text(song.artistName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button(action: onToggle) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.primary)
                }
            }
            .padding(12) // ריווח פנימי רק לחלק העליון
            
            // חלק תחתון: פס התקדמות (נצמד לקצוות)
            ProgressView(value: currentTime, total: duration > 0 ? duration : 30.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.blue) // צבע הפס
                .frame(height: 2) // דק ועדין
                .padding(.bottom, 0)
        }
        .background(.ultraThinMaterial) // אפקט הזכוכית
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal) // ריווח מהצדדים של המסך
    }
}
