protocol DemoViewInterface: AnyObject {
}

class DemoPresenter {
    private let interactor: DemoInteractor
    private unowned var view: DemoViewInterface
    
    init(view: DemoViewInterface, interactor: DemoInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func startVideo(url: String) {
        interactor.loadAsset(for: url)
        interactor.play()
    }
}
