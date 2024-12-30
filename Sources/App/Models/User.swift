//
//  User.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Fluent
import Vapor
import FluentMongoDriver

final class User: Model {
    static let schema = "users"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "phone_number")
    var phone_number: String?
    
    @Field(key: "date_of_birth")
    var date_of_birth: String?
    
    @Field(key: "profile_image")
    var profile_image: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}

    init(id: ObjectId? = nil,
         email: String,
         username: String,
         password: String,
         phone_number: String? = nil,
         date_of_birth: String? = nil,
         profile_image: String? = nil,
         createdAt: Date? = nil,
         updatedAt: Date? = nil) {
        
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.phone_number = phone_number
        self.date_of_birth = date_of_birth
        self.profile_image = profile_image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> UserDTO {
        .init(
            email: self.email,
            username: self.username,
            phoneNumber: self.phone_number ?? "",
            dateOfBirth: self.date_of_birth ?? "",
            profileImageUrl: self.profile_image ?? ""
        )
    }
}

