import AVFoundation

protocol MovieApiInterface {
    func fetchMovieDetails(id: String, completion: @escaping (Result<MovieDetails, MovieApiError>) -> Void)
    func fetchMovieCredits(id: String, completion: @escaping (Result<MovieCredits, MovieApiError>) -> Void)
}

enum MovieApiError: Error {
    case urlFailed(Error)
    case statusFailed(Int)
    case decodingFailed(Error)
    case unexpected
}

class DemoInteractor {
    private let avPlayer: AVPlayer
    private let movieApi: MovieApiInterface
    
    private(set) var movie: Movie?
    
    init(avPlayer: AVPlayer, movieApi: MovieApiInterface) {
        self.avPlayer = avPlayer
        self.movieApi = movieApi
    }
    
    func loadMovie(id: String, url: String, completion: @escaping (MovieApiError?) -> Void) {
        avPlayer.replaceCurrentItem(
            with: AVPlayerItem(asset: AVURLAsset(url: URL(string: url)!))
        )

        var movieDetailsResult: Result<MovieDetails, MovieApiError>?
        var movieCreditsResult: Result<MovieCredits, MovieApiError>?
        
        func checkResults() {
            do {
                if let details = try movieDetailsResult?.get(), let credits = try movieCreditsResult?.get() {
                    self.movie = Movie(
                        id: id,
                        title: details.originalTitle,
                        description: details.overview,
                        rating: details.voteAverage,
                        actors: credits.cast.map { actor in
                            "\(actor.name) as \"\(actor.character)\""
                        }
                    )
                    completion(nil)
                }
            } catch let error as MovieApiError {
                completion(error)
            } catch {
                completion(.unexpected)
            }
        }
        
        movieApi.fetchMovieDetails(id: id) { result in
            movieDetailsResult = result
            DispatchQueue.main.async {
                checkResults()
            }
        }
        movieApi.fetchMovieCredits(id: id) { result in
            movieCreditsResult = result
            DispatchQueue.main.async {
                checkResults()
            }
        }
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
