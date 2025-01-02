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
            .field("topic", .string, .references("topics", "name"))
            .field("level", .string, .references("levels", "level"))
            .field("created_at", .date)
            .field("updated_at", .date)
            .unique(on: "content")
            .create()
//            .deleteUnique(on: "content")
//            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("true_false_questions").delete()
    }
}
