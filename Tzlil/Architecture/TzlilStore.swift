//
//  TzlilStore.swift
//  Tzlil
//
//  Created by michal-zak on 1/14/26.
//

import Foundation
import Combine

class TzlilStore: ObservableObject {
    @Published private(set) var state = TzlilState()
    
    private let musicService: MusicServiceProtocol
    private var audioPlayer: AudioPlayerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // צינור לחיפוש עם השהייה (Debounce)
    private let searchInputSubject = PassthroughSubject<String, Never>()
    
    init(musicService: MusicServiceProtocol = MusicService(),
         audioPlayer: AudioPlayerProtocol = AudioPlayer()) {
        self.musicService = musicService
        self.audioPlayer = audioPlayer
        
        loadFavorites() // טעינת המועדפים מהזיכרון בעת העלייה
        
        // הגדרת Callback מהנגן
        self.audioPlayer.didFinishPlaying = { [weak self] in
            self?.dispatch(.audioFinished)
        }
        self.audioPlayer.onTimeUpdate = { [weak self] time in
            self?.dispatch(.updateTime(time))
        }
        
        // הגדרת Debounce לחיפוש
        searchInputSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] term in
                guard let self = self else { return }
                if term.isEmpty {
                    self.state.songs = []
                } else {
                    self.dispatch(.loadSongs(searchTerm: term))
                }
            }
            .store(in: &cancellables)
    }
    
    func dispatch(_ intent: TzlilIntent) {
        switch intent {
        case .inputChanged(let term):
            searchInputSubject.send(term)
            
        case .loadSongs(let term):
            state.isLoading = true
            state.error = nil
            musicService.searchSongs(term: term)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.state.isLoading = false
                    if case .failure(let error) = completion {
                        self?.state.error = error.localizedDescription
                    }
                }, receiveValue: { [weak self] songs in
                    self?.state.songs = songs
                })
                .store(in: &cancellables)
            
        case .play(let song):
            state.currentSong = song
            state.isPlaying = true
            if let url = URL(string: song.previewUrl) {
                audioPlayer.play(url: url)
            }
            
        case .togglePlayPause:
            state.isPlaying.toggle()
            audioPlayer.togglePlayPause(isPlaying: !state.isPlaying)
            
        case .audioFinished:
            state.isPlaying = false
            
        case .updateTime(let time):
            state.currentTime = time
            
        case .toggleFavorite(let song):
            if let index = state.favoriteSongs.firstIndex(where: { $0.id == song.id }) {
                state.favoriteSongs.remove(at: index)
            } else {
                state.favoriteSongs.append(song)
            }
            saveFavorites()
        }
    }
    
    // MARK: - Persistence
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(state.favoriteSongs) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([Song].self, from: data) {
            state.favoriteSongs = decoded
        }
    }
}
