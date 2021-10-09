import UIKit
import AVFoundation

class AVPlayerView: UIView {
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    init(avPlayer: AVPlayer) {
        super.init(frame: .zero)
        let playerLayer = layer as! AVPlayerLayer
        playerLayer.player = avPlayer
        playerLayer.videoGravity = .resizeAspect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
