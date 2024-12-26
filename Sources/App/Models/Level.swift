//
//  Level.swift
//  
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Fluent
import Vapor

enum Level_difficulty: Int, Codable {
    case level_1 = 1
    case level_2 = 2
    case level_3 = 3
}

final class Level: Model {
    static let schema = "levels"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "level")
    var level: Level_difficulty
    
    @Children(for: \.$level)
    var PartOfLevels: [PartOfLevel]
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, level: Level_difficulty, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.level = level
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> LevelDTO {
        .init(level: self.level)
    }
}

extension Level {
    static func find(byDifficulty difficulty: Level_difficulty, on db: Database) async throws -> Level? {
        try await Level.query(on: db)
            .filter(\.$level == difficulty)
            .first()
    }
}
