//
//  FavoritesView.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var store: TzlilStore
    
    var body: some View {
        NavigationView {
            VStack {
                if store.state.favoriteSongs.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("אין עדיין שירים במועדפים")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(store.state.favoriteSongs) { song in
                        let isPlayingThis = (store.state.currentSong?.id == song.id) && store.state.isPlaying
                        
                        SongRowView(
                            song: song,
                            isPlaying: isPlayingThis,
                            isFavorite: true,
                            onFavoriteToggle: { store.dispatch(.toggleFavorite(song)) }
                        )
                        .onTapGesture {
                            store.dispatch(.play(song))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("המועדפים שלי ⭐")
        }
    }
}
