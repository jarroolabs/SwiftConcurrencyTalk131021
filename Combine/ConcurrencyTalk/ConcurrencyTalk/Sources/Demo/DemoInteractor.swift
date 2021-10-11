import AVFoundation
import Combine

protocol MovieApiInterface {
    func fetchMovieDetails(id: String) -> AnyPublisher<MovieDetails, MovieApiError>
    func fetchMovieCredits(id: String) -> AnyPublisher<MovieCredits, MovieApiError>
}

enum MovieApiError: Error {
    case statusFailed(Int)
    case urlFailed(URLError)
    case decodingFailed(Error)
}

class DemoInteractor {
    private let avPlayer: AVPlayer
    private let movieApi: MovieApiInterface
    
    private(set) var movie: Movie?
    
    init(avPlayer: AVPlayer, movieApi: MovieApiInterface) {
        self.avPlayer = avPlayer
        self.movieApi = movieApi
    }
    
    func loadMovie(id: String, url: String) -> AnyPublisher<Never, Never> {
        avPlayer.replaceCurrentItem(
            with: AVPlayerItem(asset: AVURLAsset(url: URL(string: url)!))
        )
        return Publishers.CombineLatest(
            movieApi.fetchMovieDetails(id: id),
            movieApi.fetchMovieCredits(id: id)
        )
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { [weak self] details, credits in
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
        .ignoreOutput()
        .catch { _ in Empty(completeImmediately: true).setFailureType(to: Never.self) }
        .eraseToAnyPublisher()
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
