//
//  CreateLevel.swift
//  Beelearns-API
//
//  Created by Nguyễn Hưng on 26/12/2024.
//

import Fluent

struct CreateLevel: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("levels")
            .id()
            .field("level", .int, .required)
            .unique(on: "level")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("levels").delete()
    }
}
