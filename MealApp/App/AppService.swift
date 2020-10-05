import Foundation
import RxSwift
import SystemConfiguration

enum HTTPMethod: String, Equatable {
    case GET, POST, PUT, DELETE
}

enum APIPaths: String, Equatable {
    case search = "search.php"
    case categories = "categories.php"
    case random = "random.php"
    case filter = "filter.php"
    case lookup = "lookup.php"
    case list = "list.php"
}

protocol AppServiceProtocol {
    func request<T: Decodable>(path: APIPaths, method: HTTPMethod, queryItems: [URLQueryItem]?, body: [String: Any]?) -> Single<T>
}

final class AppService: AppServiceProtocol {
    private let baseUrl = "https://www.themealdb.com/api/json/v1/"
    private let apiKey = "1"
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(path: APIPaths, method: HTTPMethod, queryItems: [URLQueryItem]?, body: [String: Any]?) -> Single<T> {
        guard isNetworkAvailable else { return Single.error(ServiceError.noConnection) }

        let stringURL = baseUrl + apiKey + "/\(path.rawValue)"

        guard var urlComponents = URLComponents(string: stringURL) else { return Single.error(ServiceError.invalidURL) }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return Single.error(ServiceError.invalidURL) }

        var urlRequest = URLRequest(url: url)

        urlRequest.httpMethod = method.rawValue

        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body as Any, options: .prettyPrinted)
        }

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

//MARK: NetworkReachability

extension AppService {
    var isNetworkAvailable: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in

                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        // swiftlint:disable:next force_unwrapping
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) else { return false }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

//MARK: Service Errors

enum ServiceError: Error, Equatable {
    case generic
    case cannotParse
    case invalidURL
    case noConnection

    var readableMessage: String {
        switch self {
        case .noConnection:
            return MAString.Errors.noConnection
        default:
            return MAString.Errors.generic
        }
    }
}
