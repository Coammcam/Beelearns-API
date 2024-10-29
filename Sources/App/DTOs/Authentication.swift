//
//  File.swift
//
//
//  Created by Nguyễn Hưng on 30/10/2024.
//

import Vapor

struct RegisterDTO: Content {
    var username: String
    var email: String
    var password: String
}

struct LoginDTO: Content {
    var email: String
    var password: String
}
