import RxSwift

protocol DemoViewInterface: AnyObject {
    func setPauseViewVisibility(to isVisible: Bool)
    func updatePauseViewModel(to viewModel: PauseViewModel)
}

class DemoPresenter {
    private let interactor: DemoInteractor
    private unowned var view: DemoViewInterface
    private let bag = DisposeBag()
    private var requestedPause: Bool = false
        
    init(view: DemoViewInterface, interactor: DemoInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func loadMovie(id: String, url: String) {
        interactor
            .loadMovie(id: id, url: url)
            .subscribe(onCompleted: { [weak self] in
                let movie = (self?.interactor.movie)!
                self?.view.updatePauseViewModel(to: PauseViewModel(
                    title: movie.title,
                    description: movie.description
                ))
            })
            .disposed(by: bag)
        
        interactor.play()
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
