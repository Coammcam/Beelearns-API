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
        // Lấy `levelID` trực tiếp vì nó không phải là Optional
        let levelID = self.$level.id
        
        // Truy vấn Level dựa trên levelID
        guard let matchingLevel = try await Level.query(on: req.db)
            .filter(\.$id == levelID)
            .first() else {
            throw Abort(.notFound, reason: "Level not found.")
        }
        
        // Trả về DTO
        return PartOfLevelDTO(part: self.part, level_id: matchingLevel.level)
    }
    
}
