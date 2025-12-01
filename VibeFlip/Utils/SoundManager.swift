import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        // Configure audio session for playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error.localizedDescription)")
        }
    }
    
    /// Play the card reveal sound
    func playCardReveal() {
        if let url = Bundle.main.url(forResource: "card_reveal", withExtension: "mp3") {
            playSound(url: url)
        } else if let url = Bundle.main.url(forResource: "card_reveal", withExtension: "wav") {
            playSound(url: url)
        } else if let url = Bundle.main.url(forResource: "card_reveal", withExtension: "m4a") {
            playSound(url: url)
        } else {
            AudioServicesPlaySystemSound(1109)
        }
    }
    
    private func playSound(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.5
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Sound playback error: \(error.localizedDescription)")
            // Fallback to system sound
            AudioServicesPlaySystemSound(1057)
        }
    }
    
    /// Stop any playing sound
    func stop() {
        audioPlayer?.stop()
    }
}

