//
//  Part.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Fluent
import Vapor
import FluentMongoDriver

final class PartOfLevel: Model {
    static let schema = "part_of_levels"
    
    @ID(custom: .id)
    var id: ObjectId?
    
    @Field(key: "part")
    var part: Int
    
    @Field(key: "level")
    var level: Int
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    
    init(id: ObjectId? = nil, part: Int, level: Int, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.part = part
        self.level = level
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> PartOfLevelDTO {
        .init(part: self.part, level: self.level)
    }
}
