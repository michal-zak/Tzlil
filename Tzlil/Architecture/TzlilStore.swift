//
//  TzlilStore.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import Foundation
import Combine

class TzlilStore: ObservableObject {
    @Published private(set) var state = TzlilState()
    
    private let musicService: MusicServiceProtocol
    private var audioPlayer: AudioPlayerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // Dependency Injection
    init(musicService: MusicServiceProtocol = MusicService(),
         audioPlayer: AudioPlayerProtocol = AudioPlayer()) {
        self.musicService = musicService
        self.audioPlayer = audioPlayer
        
        // חיבור Callback מהנגן חזרה ל-Store
        self.audioPlayer.didFinishPlaying = { [weak self] in
            self?.dispatch(.audioFinished)
        }
        
        self.audioPlayer.onTimeUpdate = { [weak self] time in
            self?.dispatch(.updateTime(time))
        }
    }
    
    func dispatch(_ intent: TzlilIntent) {
        switch intent {
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
            // שינוי ה-State מיידי כדי שה-UI יגיב
            state.isPlaying.toggle()
            // ביצוע הפעולה האמיתית
            audioPlayer.togglePlayPause(isPlaying: !state.isPlaying)
            
        case .audioFinished:
            state.isPlaying = false
            
        case .updateTime(let time):
                state.currentTime = time // עדכון ה-State גורם ל-View להתריע מחדש
        }
    }
}
