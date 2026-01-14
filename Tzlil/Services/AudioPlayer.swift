//
//  AudioPlayer.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import AVFoundation

// פרוטוקול פשוט כדי שנוכל להחליף מימושים או לעשות Mock בטסטים
protocol AudioPlayerProtocol {
    func play(url: URL)
    func togglePlayPause(isPlaying: Bool)
    var didFinishPlaying: (() -> Void)? { get set }
    var onTimeUpdate: ((Double) -> Void)? { get set } // Callback חדש
}

class AudioPlayer: NSObject, AudioPlayerProtocol {
    private var player: AVPlayer?
    var didFinishPlaying: (() -> Void)?
    var onTimeUpdate: ((Double) -> Void)?
    private var timeObserver: Any? // לשמירת הרפרנס
    
    override init() {
        super.init()
    }
    
    func play(url: URL) {
        // 1. ניקוי יסודי של הנגן הישן לפני יצירת החדש
        if let player = player {
            player.pause()
            if let observer = timeObserver {
                player.removeTimeObserver(observer)
                timeObserver = nil
            }
        }
        
        // ניקוי האזנות NotificationCenter ישנות
        NotificationCenter.default.removeObserver(self)
        
        // 2. יצירת הנגן החדש
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
        
        // 3. הוספת האזנה לזמן לנגן החדש
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            // בדיקה שהנגן הנוכחי הוא עדיין הנגן שרצינו (מונע Race Conditions)
            guard let self = self, self.player?.currentItem?.status == .readyToPlay else { return }
            self.onTimeUpdate?(time.seconds)
        }
        
        // האזנה לסיום השיר
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
            self?.didFinishPlaying?()
        }
    }
    
    func togglePlayPause(isPlaying: Bool) {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
    }
}
