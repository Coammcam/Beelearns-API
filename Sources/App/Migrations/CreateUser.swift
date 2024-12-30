//
//  CreateUser.swift
//
//
//  Created by Nguyễn Hưng on 20/10/2024.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("phone_number", .string, .required)
            .field("date_of_birth", .string)
            .field("profile_image", .string)
            .field("heart", .int, .required)
            .field("honey_jar", .int, .required)
            .field("level", .int, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
