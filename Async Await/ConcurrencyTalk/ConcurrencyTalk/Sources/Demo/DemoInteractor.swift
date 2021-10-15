import AVFoundation

protocol MovieApiInterface {
    func fetchMovieDetails(id: String) async throws -> MovieDetails
    func fetchMovieCredits(id: String) async throws -> MovieCredits
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
    
    func loadMovie(id: String, url: String) async {
        avPlayer.replaceCurrentItem(
            with: AVPlayerItem(asset: AVURLAsset(url: URL(string: url)!))
        )
        
        async let details = movieApi.fetchMovieDetails(id: id)
        async let credits = movieApi.fetchMovieCredits(id: id)
        
        do {
            movie = try await Movie(
                id: id,
                title: details.originalTitle,
                description: details.overview,
                rating: details.voteAverage,
                actors: credits.cast.map { actor in
                    "\(actor.name) as \"\(actor.character)\""
                }
            )
        } catch let error as URLError {
            // Handle URL errors
            _ = error
        } catch let error as MovieApiError {
            // Handle API errors
            _ = error
        } catch {
            // Handle other errors here, like decoding errors
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
