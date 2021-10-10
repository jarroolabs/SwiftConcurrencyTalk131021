import RxCocoa
import RxSwift
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
    
    func fetchMovieDetails(id: String) -> Single<MovieDetails> {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)"))
        request.httpMethod = "GET"

        return urlSession
            .rx.response(request: request)
            .map { response, data in
                if 200 ..< 300 ~= response.statusCode {
                    return try decoder.decode(MovieDetails.self, from: data)
                } else {
                    throw MovieApiError.statusFailed(response.statusCode)
                }
            }
            .take(1)
            .asSingle()
    }
    
    func fetchMovieCredits(id: String) -> Single<MovieCredits> {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)/credits"))
        request.httpMethod = "GET"

        return urlSession
            .rx.response(request: request)
            .map { response, data in
                if 200 ..< 300 ~= response.statusCode {
                    return try decoder.decode(MovieCredits.self, from: data)
                } else {
                    throw MovieApiError.statusFailed(response.statusCode)
                }
            }
            .take(1)
            .asSingle()

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
