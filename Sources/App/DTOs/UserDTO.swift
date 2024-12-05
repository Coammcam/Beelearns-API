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
//    var password: String
    var phoneNumber: String?
    var dateOfBirth: String?
    var profileImageUrl: String?
    var heart: Int?
    var honey_jar: Int?
    
    func toModel() -> User {
        let model = User()
        
        model.username = self.username
        model.email = self.email
        model.phone_number = self.phoneNumber
        model.date_of_birth = self.dateOfBirth
        model.profile_image = self.profileImageUrl
//        model.password = self.password
        model.heart = self.heart
        model.honey_jar = self.honey_jar
        
        
        return model
    }
}
