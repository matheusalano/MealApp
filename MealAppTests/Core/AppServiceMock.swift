import Foundation
import RxSwift

@testable import MealApp

final class AppServiceMock<W>: AppServiceProtocol {
    var path: Observable<APIPaths> {
        _path.asObservable()
    }

    var method: Observable<HTTPMethod> {
        _method.asObservable()
    }

    var queryItems: Observable<[URLQueryItem]> {
        _queryItems.asObservable()
    }

    var body: Observable<[String: Any]> {
        _body.asObservable()
    }

    private let result: Result<W, ServiceError>

    private let _path = PublishSubject<APIPaths>()
    private let _method = PublishSubject<HTTPMethod>()
    private let _queryItems = PublishSubject<[URLQueryItem]>()
    private let _body = PublishSubject<[String: Any]>()

    init(result: Result<W, ServiceError>) {
        self.result = result
    }

    func request<T>(path: APIPaths, method: HTTPMethod, queryItems: [URLQueryItem]?, body: [String: Any]?) -> Single<T> where T: Decodable {
        _path.onNext(path)
        _method.onNext(method)

        if let queryItems = queryItems {
            _queryItems.onNext(queryItems)
        }

        if let body = body {
            _body.onNext(body)
        }

        switch result {
        case let .success(data):
            // swiftlint:disable:next force_cast
            return Single.just(data as! T)
        case let .failure(error):
            return Single.error(error)
        }
    }
}
