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
    
    func fetchMovieDetails(id: String, completion: @escaping (Result<MovieDetails, MovieApiError>) -> Void) {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)"))
        request.httpMethod = "GET"

        urlSession
            .dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(.urlFailed(error)))
                } else if let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            completion(.success(try decoder.decode(MovieDetails.self, from: data)))
                        } catch {
                            completion(.failure(.decodingFailed(error)))
                        }
                    } else {
                        completion(.failure(.statusFailed(statusCode)))
                    }
                } else {
                    completion(.failure(.unexpected))
                }
            })
            .resume()
    }
    
    func fetchMovieCredits(id: String, completion: @escaping (Result<MovieCredits, MovieApiError>) -> Void) {
        var request = URLRequest(url: urlFor(path: "/3/movie/\(id)/credits"))
        request.httpMethod = "GET"

        urlSession
            .dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(.urlFailed(error)))
                } else if let data = data, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            completion(.success(try decoder.decode(MovieCredits.self, from: data)))
                        } catch {
                            completion(.failure(.decodingFailed(error)))
                        }
                    } else {
                        completion(.failure(.statusFailed(statusCode)))
                    }
                } else {
                    completion(.failure(.unexpected))
                }
            })
            .resume()
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
