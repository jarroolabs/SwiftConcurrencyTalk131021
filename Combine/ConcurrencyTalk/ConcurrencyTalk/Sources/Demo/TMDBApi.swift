import Combine
import Foundation

struct TMDBApi: MovieApiInterface {
    let host = "https://api.themoviedb.org"
    let urlSession: URLSession
    let apiKey: String
    let language: String
    let decoder: JSONDecoder
    
    init(urlSession: URLSession, apiKey: String, language: String) {
        self.urlSession = urlSession
        self.apiKey = apiKey
        self.language = language
        
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchMovieDetails(id: String) -> AnyPublisher<MovieDetails, MovieApiError> {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)"))
        request.httpMethod = "GET"

        return urlSession
            .dataTaskPublisher(for: request)
            .mapError(MovieApiError.urlFailed)
            .flatMap { data, response -> AnyPublisher<MovieDetails, MovieApiError> in
                guard 200 ..< 300 ~= response.httpStatusCode! else {
                    return Fail(error: MovieApiError.statusFailed(response.httpStatusCode!)).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: MovieDetails.self, decoder: decoder)
                    .mapError(MovieApiError.decodingFailed)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCredits(id: String) -> AnyPublisher<MovieCredits, MovieApiError> {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)/credits"))
        request.httpMethod = "GET"

        return urlSession
            .dataTaskPublisher(for: request)
            .mapError(MovieApiError.urlFailed)
            .flatMap { data, response -> AnyPublisher<MovieCredits, MovieApiError> in
                guard 200 ..< 300 ~= response.httpStatusCode! else {
                    return Fail(error: MovieApiError.statusFailed(response.httpStatusCode!)).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: MovieCredits.self, decoder: decoder)
                    .mapError(MovieApiError.decodingFailed)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

    }
    
    private func urlFor(path: String) -> URL {
        var urlComponents = URLComponents(string: host)
        urlComponents?.path = path
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]
        return (urlComponents?.url)!
    }
}

struct MovieDetails: Decodable {
    let originalTitle: String
    let overview: String
    let voteAverage: Float
}

struct MovieCredits: Decodable {
    let cast: [Actor]
}

struct Actor: Decodable {
    let name: String
    let character: String
}

extension URLResponse {
    func hasHttpStatusCode(inRange range: Range<Int>) -> Bool {
        guard let statusCode = httpStatusCode else { return false }
        return range ~= statusCode
    }

    var httpStatusCode: Int? {
        (self as? HTTPURLResponse)?.statusCode
    }
}
