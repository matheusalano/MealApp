import Foundation
import RxSwift

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum ServiceError: Error {
    case cannotParse
    case invalidURL
}

enum APIPaths: String {
    case search = "search.php"
}

protocol AppServiceProtocol {
    func request<T: Decodable>(path: APIPaths, method: HTTPMethod, queryItems: [URLQueryItem]?) -> Single<T>
}

class AppService: AppServiceProtocol {
    private let baseUrl = "https://www.themealdb.com/api/json/v1/"
    private let apiKey = "1"
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(path: APIPaths, method: HTTPMethod, queryItems: [URLQueryItem]?) -> Single<T> {
        let stringURL = baseUrl + apiKey + "/\(path.rawValue)"

        guard var urlComponents = URLComponents(string: stringURL) else { return Single.error(ServiceError.invalidURL) }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return Single.error(ServiceError.invalidURL) }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue

        return session.rx
            .json(request: urlRequest)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asSingle()
            .flatMap({ json throws -> Single<T> in
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: json, options: .prettyPrinted))

                    return .just(jsonData)
                } catch {
                    print(error.localizedDescription)
                    return .error(ServiceError.cannotParse)
                }
            })
    }
}
