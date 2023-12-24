//
//  URLSessionDataTaskFake.swift
//  BackpackTests
//
//  Created by Sylvain Druaux on 09/02/2023.
//

import Foundation

class URLSessionDataTaskFake: URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() {
        // Nothing to cancel since we don't make real network request
    }
}
