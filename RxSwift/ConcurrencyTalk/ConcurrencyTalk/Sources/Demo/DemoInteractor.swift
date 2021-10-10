import RxSwift
import AVFoundation

protocol MovieApiInterface {
    func fetchMovieDetails(id: String) -> Single<MovieDetails>
    func fetchMovieCredits(id: String) -> Single<MovieCredits>
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
        return Observable
            .combineLatest(
                movieApi.fetchMovieDetails(id: id).asObservable(),
                movieApi.fetchMovieCredits(id: id).asObservable()
            )
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] details, credits in
                self?.movie = Movie(
                    id: id,
                    title: details.originalTitle,
                    description: details.overview,
                    rating: details.voteAverage,
                    actors: credits.cast.map { actor in
                        "\(actor.name) as \"\(actor.character)\""
                    }
                )
            })
            .flatMap { _ in Observable<Never>.empty() }
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
    let actors: [String]
}
