//
//  CreateWord.swift
//  
//
//  Created by HoangDus on 24/10/2024.
//

import Fluent

struct CreateWord: AsyncMigration{
    func prepare(on database: Database) async throws {
        try await database.schema("words")
            .id()
            .field("english_word", .string, .required)
            .field("vietnamese_meaning", .string, .required)
            .field("created_at", .date)
            .field("updated_at", .date)
            .unique(on: "english_word")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("words").delete()
    }
}
