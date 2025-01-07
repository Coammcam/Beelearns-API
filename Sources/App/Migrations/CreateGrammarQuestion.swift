//
//  CreateGrammarQuestion.swift
//  
//
//  Created by HoangDus on 27/12/2024.
//

import Fluent

struct CreateGrammarQuestion: AsyncMigration{
    func prepare(on database: FluentKit.Database) async throws {
        try await database.schema("grammar-questions")
            .id()
            .field("question", .string, .required)
            .field("content", .string, .required)
            .field("meaning", .string, .required)
            .field("topic", .string, .required, .references("topics", "name"))
            .field("level", .string, .required, .references("levels", "level"))
            .field("create_at", .date)
            .field("update_at", .date)
            .unique(on: "content")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("grammar-questions").delete()
    }
}
