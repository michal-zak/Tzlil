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
                    List {
                        // בדיקה: האם יש לנו המלצות להציג?
                        if let recGenre = store.state.recommendedGenre, !store.state.songs.isEmpty {
                            
                            // סינון לקבוצות (בזמן אמת ל-UI)
                            let recommended = store.state.songs.filter { $0.primaryGenreName == recGenre }
                            let others = store.state.songs.filter { $0.primaryGenreName != recGenre }
                            
                            // קבוצה 1: מומלצים
                            if !recommended.isEmpty {
                                Section(header: HStack {
                                    Text("במיוחד בשבילך")
                                    Image(systemName: "sparkles").foregroundColor(.yellow)
                                    Text("(\(recGenre))").font(.caption).foregroundColor(.gray)
                                }) {
                                    ForEach(recommended) { song in
                                        songRow(for: song, isRecommended: true)
                                    }
                                }
                            }
                            
                            // קבוצה 2: השאר
                            if !others.isEmpty {
                                Section(header: Text("תוצאות נוספות")) {
                                    ForEach(others) { song in
                                        songRow(for: song, isRecommended: false)
                                    }
                                }
                            }
                            
                        } else {
                            // אם אין המלצות, מציגים רשימה רגילה
                            ForEach(store.state.songs) { song in
                                songRow(for: song, isRecommended: false)
                            }
                        }
                    }
                    .listStyle(.insetGrouped) // סגנון מודרני יותר שמפריד יפה סקשנים
                }
            }
            .navigationTitle("חיפוש 🎵")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onChange(of: searchText) { newValue in
                store.dispatch(.inputChanged(newValue))
            }
        }
    }
    
    // פונקציית עזר לבניית השורה כדי למנוע שכפול קוד
    @ViewBuilder
    private func songRow(for song: Song, isRecommended: Bool) -> some View {
        let isPlayingThis = (store.state.currentSong?.id == song.id) && store.state.isPlaying
        let isFav = store.state.isFavorite(song)
        
        SongRowView(
            song: song,
            isPlaying: isPlayingThis,
            isFavorite: isFav,
            isRecommended: isRecommended, // העברת פרמטר ההמלצה
            onFavoriteToggle: { store.dispatch(.toggleFavorite(song)) }
        )
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            store.dispatch(.play(song))
        }
    }
}
