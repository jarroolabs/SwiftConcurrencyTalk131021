import AVFoundation
import UIKit

class DemoViewController: UIViewController, DemoViewInterface {
    private let playerView: AVPlayerView
    var presenter: DemoPresenter!
    
    static func make() -> DemoViewController {
        let player = AVPlayer()
        let viewController = DemoViewController(avPlayer: player)
        viewController.presenter = DemoPresenter(view: viewController, interactor: DemoInteractor(avPlayer: player))
        return viewController
    }
    
    private init(avPlayer: AVPlayer) {
        playerView = AVPlayerView(avPlayer: avPlayer)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        presenter.startVideo(
            url: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
