import AVFoundation
import UIKit

class DemoViewController: UIViewController, DemoViewInterface {
    private let playerView: AVPlayerView
    private let pauseView: PauseView

    var presenter: DemoPresenter!
    
    static func make() -> DemoViewController {
        let player = AVPlayer()
        let viewController = DemoViewController(avPlayer: player)
        viewController.presenter = DemoPresenter(
            view: viewController,
            interactor: DemoInteractor(
                avPlayer: player,
                movieApi: TMDBApi(
                    urlSession: .shared,
                    apiKey: "2c72472691b209509f451fdfb0479e8b",
                    language: "en-US"
                )
            )
        )
        return viewController
    }
    
    private init(avPlayer: AVPlayer) {
        playerView = AVPlayerView(avPlayer: avPlayer)
        pauseView = PauseView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
        
        layoutPlayerView()
        
        layoutPauseView()
        pauseView.isHidden = true
        
        presenter.loadMovie(
            id: "133701",
            url: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"
        )
    }
    
    func setPauseViewVisibility(to isVisible: Bool) {
        let duration = TimeInterval(0.44)
        pauseView.isHidden = false

        if isVisible {
            pauseView.alpha = 0
            UIView.animate(withDuration: duration, animations: {
                self.pauseView.alpha = 1
            })
        } else {
            pauseView.alpha = 1
            UIView.animate(
                withDuration: duration,
                animations: { self.pauseView.alpha = 0 },
                completion: { _ in self.pauseView.isHidden = true }
            )
        }
    }
    
    func updatePauseViewModel(to viewModel: PauseViewModel) {
        pauseView.updateViewModel(to: viewModel)
    }
    
    @objc private func viewPressed() {
        presenter.togglePause()
    }
    
    private func layoutPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func layoutPauseView() {
        pauseView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseView)
        NSLayoutConstraint.activate([
            pauseView.topAnchor.constraint(equalTo: view.topAnchor),
            pauseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pauseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pauseView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
