//
//  SearchView.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var store: TzlilStore
    @Binding var searchText: String
    
    var body: some View {
        NavigationView {
            VStack {
                if store.state.isLoading {
                    ProgressView("מחפש...")
                } else if store.state.songs.isEmpty && searchText.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "music.mic")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("התחל להקליד כדי לחפש")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(store.state.songs) { song in
                        let isPlayingThis = (store.state.currentSong?.id == song.id) && store.state.isPlaying
                        let isFav = store.state.isFavorite(song)
                        
                        SongRowView(
                            song: song,
                            isPlaying: isPlayingThis,
                            isFavorite: isFav,
                            onFavoriteToggle: { store.dispatch(.toggleFavorite(song)) }
                        )
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            store.dispatch(.play(song))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("חיפוש 🎵")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { newValue in
                store.dispatch(.inputChanged(newValue))
            }
        }
    }
}
