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
    
    func fetchMovieDetails(id: String) async throws -> MovieDetails {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)"))
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)

        guard 200 ..< 300 ~= response.httpStatusCode! else {
            throw MovieApiError.statusFailed(response.httpStatusCode!)
        }
        return try decoder.decode(MovieDetails.self, from: data)
    }
    
    func fetchMovieCredits(id: String) async throws -> MovieCredits {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)/credits"))
        request.httpMethod = "GET"

        let (data, response) = try await urlSession.data(for: request)
        
        guard 200 ..< 300 ~= response.httpStatusCode! else {
            throw MovieApiError.statusFailed(response.httpStatusCode!)
        }
        return try decoder.decode(MovieCredits.self, from: data)
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
