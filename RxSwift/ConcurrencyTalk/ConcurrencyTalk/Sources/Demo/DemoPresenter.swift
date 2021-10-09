protocol DemoViewInterface: AnyObject {
}

class DemoPresenter {
    private let interactor: DemoInteractor
    private unowned var view: DemoViewInterface
    
    init(view: DemoViewInterface, interactor: DemoInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func loadMovie(id: String, url: String) {
        interactor.loadMovie(id: id, url: url)
        interactor.play()
    }
}
