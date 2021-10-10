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
    
    private(set) var movie: Movie?
    
    init(avPlayer: AVPlayer, movieApi: MovieApiInterface) {
        self.avPlayer = avPlayer
        self.movieApi = movieApi
    }
    
    func loadMovie(id: String, url: String) -> Completable {
        avPlayer.replaceCurrentItem(
            with: AVPlayerItem(asset: AVURLAsset(url: URL(string: url)!))
        )
        return movieApi
            .fetchMovieDetails(id: id)
            .observe(on: MainScheduler.instance)
            .do(onSuccess: { [weak self] movieDetails in
                self?.movie = Movie(
                    id: id,
                    title: movieDetails.originalTitle,
                    description: movieDetails.overview,
                    rating: movieDetails.voteAverage
                )
            })
            .asCompletable()
    }
    
    func play() {
        avPlayer.play()
    }
    
    func pause() {
        avPlayer.pause()
    }
}

struct Movie {
    let id: String
    let title: String
    let description: String
    let rating: Float // out of 10
}
