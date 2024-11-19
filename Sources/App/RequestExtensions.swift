//
//  RequestExtensions.swift
//
//
//  Created by Nguyễn Hưng on 19/11/2024.
//

import Vapor

extension Request {
    func withQuery(_ key: String, value: String) -> Request {
        var modifiedRequest = self
        modifiedRequest.url.query = "\(key)=\(value)"
        return modifiedRequest
    }
}
