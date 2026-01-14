//
//  AudioPlayer.swift
//  Tzlil
//
//  Created by user945522 on 1/14/26.
//

import AVFoundation

protocol AudioPlayerProtocol {
    func play(url: URL)
    func togglePlayPause(isPlaying: Bool)
    var didFinishPlaying: (() -> Void)? { get set }
    var onTimeUpdate: ((Double) -> Void)? { get set }
}

class AudioPlayer: NSObject, AudioPlayerProtocol {
    private var player: AVPlayer?
    var didFinishPlaying: (() -> Void)?
    var onTimeUpdate: ((Double) -> Void)?
    private var timeObserver: Any?
    
    override init() {
        super.init()
        // הגדרת סשן אודיו כדי שינגן גם כשהמתג על שקט
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func play(url: URL) {
        // 1. ניקוי נגן קודם למניעת קריסות וזליגות זיכרון
        if let player = player {
            player.pause()
            if let observer = timeObserver {
                player.removeTimeObserver(observer)
                timeObserver = nil
            }
        }
        NotificationCenter.default.removeObserver(self)
        
        // 2. יצירת נגן חדש
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
        
        // 3. דיווח זמן כל חצי שנייה
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self, self.player?.currentItem?.status == .readyToPlay else { return }
            self.onTimeUpdate?(time.seconds)
        }
        
        // 4. האזנה לסיום השיר
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
