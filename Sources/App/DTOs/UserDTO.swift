//
//  UserDTO.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Vapor

struct UserDTO: Content {
    var email: String
    var username: String
    var phoneNumber: String?
    var dateOfBirth: String?
    var profileImageUrl: String?
    
    func toModel() -> User {
        let model = User()
        
        model.username = self.username
        model.email = self.email
        model.phone_number = self.phoneNumber
        model.date_of_birth = self.dateOfBirth
        model.profile_image = self.profileImageUrl
        return model
    }
}


struct UserStudyDataDTO: Content{
    var score: Int
    var exp: Int
    var part: Int
    var level: Int
    var honeyComb: Int
    var honeyJar: Int
}
