//
//  CreateTrueFalseQuestion.swift
//  
//
//  Created by HoangDus on 31/10/2024.
//

import Fluent

struct CreateTrueFalseQuestion: AsyncMigration{
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("true_false_questions")
            .id()
            .field("content", .string, .required)
            .field("answer", .bool, .required)
            .field("vietnamese_meaning", .string, .required)
            .field("correction", .string)
            .field("topic", .string)
            .field("created_at", .date)
            .field("updated_at", .date)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("true_false_questions").delete()
    }
}
