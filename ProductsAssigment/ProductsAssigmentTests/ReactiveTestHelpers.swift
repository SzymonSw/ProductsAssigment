//
//  ReactiveTestHelpers.swift
//  ProductsAssigmentTests
//
//  Created by Szymon Swietek on 26/02/2023.
//

import Combine
import XCTest

extension Published.Publisher {
    func collectNext(_ count: Int) -> AnyPublisher<[Output], Never> {
        dropFirst()
            .collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}

extension XCTestCase {
    @discardableResult func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 1.5,
        file _: StaticString = #file,
        line _: UInt = #line
    ) throws -> T.Output {
      
        var result: Result<T.Output, Error>?
        let expectation = XCTestExpectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
            }
        )
    
        _ = XCTWaiter.wait(for: [expectation], timeout: timeout)
        cancellable.cancel()

        guard let result else { throw ReactiveHelperErrors.nilReturned }

        switch result {
        case let .success(r):
            return r
        case let .failure(e):
            throw e
        }
    }
}

enum ReactiveHelperErrors: Error {
    case nilReturned
}
