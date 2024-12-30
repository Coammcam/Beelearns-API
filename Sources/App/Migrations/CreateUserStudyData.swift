//
//  CreateUserStudyData.swift
//  
//
//  Created by HoangDus on 28/12/2024.
//

import Fluent

struct CreateUserStudyData: AsyncMigration{
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("user_study_data")
            .id()
            .field("user_email", .string, .required, .references("users", "email"))
            .field("score", .int, .required)
            .field("exp", .int, .required)
            .field("part", .int, .required)
            .field("level", .int, .required)
            .field("heart", .int, .required)
            .field("honey_jar", .int, .required)
            .unique(on: "user_email")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("user_study_data").delete()
    }
}
