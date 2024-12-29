//
//  Level.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Fluent
import Vapor
import FluentMongoDriver

final class Level: Model {
    static let schema = "levels"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "level")
    var level: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: ObjectId? = nil, level: Int, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.level = level
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> LevelDTO {
        .init(level: self.level)
    }
}
