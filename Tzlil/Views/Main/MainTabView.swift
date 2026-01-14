//
//  ContentView.swift
//  Tzlil
//
//  Created by user945522 on 1/13/26.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var store = TzlilStore()
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                SearchView(store: store, searchText: $searchText)
                    .tabItem { Label("חיפוש", systemImage: "magnifyingglass") }
                
                FavoritesView(store: store)
                    .tabItem { Label("מועדפים", systemImage: "star.fill") }
            }
            .accentColor(.blue)
            
            if let currentSong = store.state.currentSong {
                MiniPlayerView(
                    song: currentSong,
                    isPlaying: store.state.isPlaying,
                    currentTime: store.state.currentTime,
                    duration: store.state.duration,
                    onToggle: { store.dispatch(.togglePlayPause) }
                )
                .padding(.bottom, 50)
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: currentSong)
                .zIndex(1)
            }
        }
    }
}
