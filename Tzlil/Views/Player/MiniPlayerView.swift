//
//  MiniPlayerView.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import SwiftUI

struct MiniPlayerView: View {
    let song: Song
    let isPlaying: Bool
    let currentTime: Double
    let duration: Double
    let onToggle: () -> Void
    
    private func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d דקות ו-%d שניות", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                AsyncImage(url: URL(string: song.artworkUrl100)) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 44, height: 44)
                .cornerRadius(6)
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.trackName).font(.headline).lineLimit(1)
                    Text(song.artistName).font(.caption).foregroundColor(.secondary).lineLimit(1)
                }.accessibilityElement(children: .combine)
                    .accessibilityLabel("מתנגן כעת: \(song.trackName)")
                
                Spacer()
                
                Button(action: onToggle) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.primary)
                }.accessibilityLabel(isPlaying ? "השהה" : "נגן")
                .accessibilityRemoveTraits(.isImage)
            }
            .padding(12)
            
            ProgressView(value: currentTime, total: duration > 0 ? duration : 30.0)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.blue)
                .frame(height: 2)
                .padding(.bottom, 0)
                .accessibilityLabel("זמן ניגון")
                .accessibilityValue("\(Int(currentTime)) שניות מתוך \(Int(duration))")
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .accessibilityElement(children: .contain) // מאפשר דפדוף בין האלמנטים בתוך הנגן
    }
}
