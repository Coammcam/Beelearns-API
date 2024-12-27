//
//  CreatePart.swift
//  Beelearns-API
//
//  Created by Nguyễn Hưng on 26/12/2024.
//

import Fluent

struct CreatePartOfLevels: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("part_of_levels")
            .id()
            .field("part", .int, .required)
            .unique(on: "part")
            .field("level", .int, .required, .references("levels", "level", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("part_of_levels").delete()
    }
}
