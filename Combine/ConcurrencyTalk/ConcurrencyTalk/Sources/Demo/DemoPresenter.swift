import Combine

protocol DemoViewInterface: AnyObject {
    func setPauseViewVisibility(to isVisible: Bool)
    func updatePauseViewModel(to viewModel: PauseViewModel)
}

class DemoPresenter {
    private let interactor: DemoInteractor
    private unowned var view: DemoViewInterface
    private var cancellables = Set<AnyCancellable>()
    private var requestedPause: Bool = false
        
    init(view: DemoViewInterface, interactor: DemoInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        loadMovie(
            id: "133701",
            url: "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"
        )
    }
    
    func loadMovie(id: String, url: String) {
        interactor.play()

        interactor
            .loadMovie(id: id, url: url)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.view.updatePauseViewModel(
                    to: PauseViewModelMapper(movie: self.interactor.movie!).map()
                )
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    func togglePause() {
        requestedPause.toggle()
        view.setPauseViewVisibility(to: requestedPause)
        
        if requestedPause {
            interactor.pause()
        } else {
            interactor.play()
        }
    }
}

private struct PauseViewModelMapper {
    let movie: Movie
    
    func map() -> PauseViewModel {
        PauseViewModel(
            title: mapTitleWithStars(),
            description: movie.description,
            actors: movie.actors.prefix(5).joined(separator: "\n")
        )
    }
    
    private func mapTitleWithStars() -> String {
        let starRating = Int(((movie.rating / 10) * 5).rounded(.up))
        let filledStars = Array(repeating: "★", count: starRating)
        let emptyStars = Array(repeating: "☆", count: 5-starRating)
        return "\(movie.title) \(filledStars.joined(separator: ""))\(emptyStars.joined(separator: ""))"
    }
}
