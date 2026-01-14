//
//  ContentView.swift
//  Tzlil
//
//  Created by user945522 on 1/13/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = TzlilStore()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // 1. רשימת השירים (התוכן הראשי)
                VStack {
                    if store.state.isLoading {
                        ProgressView("טוען שירים...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = store.state.error {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text(error)
                        }
                        .foregroundColor(.red)
                    } else {
                        List(store.state.songs) { song in
                            // בודקים אם השיר הזה מנגן עכשיו כדי לסמן אותו
                            let isPlayingThis = (store.state.currentSong?.id == song.id) && store.state.isPlaying
                            
                            SongRowView(song: song, isPlaying: isPlayingThis)
                                .onTapGesture {
                                    store.dispatch(.play(song))
                                }
                        }
                        .listStyle(.plain)
                    }
                }
                
                // 2. הנגן הקטן (Mini Player Overlay)
                if let currentSong = store.state.currentSong {
                    MiniPlayerView(
                        song: currentSong,
                        isPlaying: store.state.isPlaying,
                        // 👇 הנה השינוי שביקשת:
                        currentTime: store.state.currentTime,
                        duration: store.state.duration,
                        onToggle: { store.dispatch(.togglePlayPause) }
                    )
                    .padding(.bottom, 10)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: currentSong)
                }
            }
            .navigationTitle("Tzlil 🎵")
            .onAppear {
                if store.state.songs.isEmpty {
                    store.dispatch(.loadSongs(searchTerm: "Omer Adam"))
                }
            }
        }
    }
}
