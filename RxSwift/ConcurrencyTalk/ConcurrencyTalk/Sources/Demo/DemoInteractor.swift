import AVFoundation

struct DemoInteractor {
    private let avPlayer: AVPlayer

    init(avPlayer: AVPlayer) {
        self.avPlayer = avPlayer
    }
        
    func loadAsset(for urlString: String) {
        let item = AVPlayerItem(asset: AVURLAsset(url: URL(string: urlString)!))
        avPlayer.replaceCurrentItem(with: item)
    }
    
    func play() {
        avPlayer.play()
    }
}
