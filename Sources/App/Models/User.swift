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
    
    @Field(key: "heart")
    var heart: Int?
    
    @Field(key: "honey_jar")
    var honey_jar: Int?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, username: String, email: String, password: String, phone_number: String? = nil, date_of_birth: String? = nil ,profile_image: String? = nil, heart: Int? = 5, honey_jar: Int? = 100) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.phone_number = phone_number
        self.date_of_birth = date_of_birth
        self.profile_image = profile_image
        self.heart = heart
        self.honey_jar = honey_jar
    }
    
    func toDTO() -> UserDTO {
        .init(
            email: self.email,
            username: self.username,
//            password: self.password,
            phoneNumber: self.phone_number ?? "",
            dateOfBirth: self.date_of_birth ?? "",
            profileImageUrl: self.profile_image ?? "",
            heart: self.heart,
            honey_jar: self.honey_jar
        )
    }
    
}
