//
//  File.swift
//  
//
//  Created by Nguyễn Hưng on 25/10/2024.
//

import Vapor

struct ChangePasswordDTO: Content {
    var email: String
    var oldPassword: String
    var newPassword: String
}
