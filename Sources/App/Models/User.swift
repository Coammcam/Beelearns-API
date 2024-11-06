//
//  User.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
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
    
    init(id: UUID? = nil, username: String, email: String, password: String, phone_number: String? = nil, date_of_birth: String? = nil ,profile_image: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.phone_number = phone_number
        self.date_of_birth = date_of_birth
        self.profile_image = profile_image
    }
    
    func toDTO() -> UserDTO {
        .init(
            email: self.email,
            username: self.username,
//            password: self.password,
            phone_number: self.phone_number ?? "",
            date_of_birth: self.date_of_birth ?? "",
            profile_image: self.profile_image ?? ""
        )
    }
    
}
