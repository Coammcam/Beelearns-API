//
//  Part.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Fluent
import Vapor

final class PartOfLevel: Model {
    static let schema = "part_of_levels"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "part")
    var part: Int
    
    @Parent(key: "level_id")
    var level: Level
    
    init() {}
    
    init(id: UUID? = nil,part: Int ,levelID: UUID) {
        self.id = id
        self.part = part
        self.$level.id = levelID
    }
    
    func toDTO(req: Request) async throws -> PartOfLevelDTO {
        let levelID = self.$level.id
        
        guard let matchingLevel = try await Level.query(on: req.db)
            .filter(\.$id == levelID)
            .first() else {
            throw Abort(.notFound, reason: "Level not found.")
        }
        
        return PartOfLevelDTO(part: self.part, level_id: matchingLevel.level)
    }
    
}
