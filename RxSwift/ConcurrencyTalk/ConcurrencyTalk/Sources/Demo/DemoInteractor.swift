import RxSwift
import AVFoundation

protocol MovieApiInterface {
    func fetchMovieDetails(id: String) -> Single<MovieDetails>
//    func fetchMovieCredits(id: String) -> Single<MovieCredits>
}

enum MovieApiError: Error {
    case statusFailed(Int)
}

class DemoInteractor {
    private let avPlayer: AVPlayer
    private let movieApi: MovieApiInterface
    private let bag = DisposeBag()
    
    init(avPlayer: AVPlayer, movieApi: MovieApiInterface) {
        self.avPlayer = avPlayer
        self.movieApi = movieApi
    }
    
    func loadMovie(id: String, url: String) {
        avPlayer.replaceCurrentItem(
            with: AVPlayerItem(asset: AVURLAsset(url: URL(string: url)!))
        )
        movieApi
            .fetchMovieDetails(id: id)
            .subscribe(
                onSuccess: { movieDetails in
                    print(movieDetails)
                },
                onFailure: { error in
                    print(error)
                }
            )
            .disposed(by: bag)
    }
    
    func play() {
        avPlayer.play()
    }
}
