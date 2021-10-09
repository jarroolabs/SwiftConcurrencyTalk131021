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
        var urlComponents = URLComponents(string: host)
        urlComponents?.path = "/3/movie/\(id)"
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ]
        var request = URLRequest(url: (urlComponents?.url)!)
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
}

struct MovieDetails: Decodable {
    let originalTitle: String
    let overview: String
    let voteAverage: Float
}
