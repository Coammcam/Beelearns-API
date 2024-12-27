//
//  PartOfLevelController.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor
import Fluent

struct PartOfLevelController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let partOfLevelRoute = routes.grouped("part_of_level")
        
        partOfLevelRoute.post(use: addPartOfLevel)
    }
    
    func addPartOfLevel(req: Request) async throws -> PartOfLevelDTO {
        let partOfLevelDTO = try req.content.decode(PartOfLevelDTO.self)
        
        guard let currentLevel = try await Level.query(on: req.db)
            .filter(\.$level == partOfLevelDTO.level_id)
            .first(), let currentLevelID = currentLevel.id else {
            throw Abort(.notFound, reason: "Level not found for the provided difficulty.")
        }
        
        if let previousLevelDifficulty = Level_difficulty(rawValue: partOfLevelDTO.level_id.rawValue - 1),
           let previousLevel = try await Level.query(on: req.db)
            .filter(\.$level == previousLevelDifficulty)
            .first() {
            
            // Lấy part lớn nhất của Level trước đó
            let maxPartInPreviousLevel = try await PartOfLevel.query(on: req.db)
                .filter(\.$level.$id == previousLevel.id!)
                .sort(\.$part, .descending)
                .first()?.part ?? 0
            
            if partOfLevelDTO.part <= maxPartInPreviousLevel {
                throw Abort(.badRequest, reason: "The part must be greater than the maximum part in the previous level.")
            }
        }
        
        let partOfLevel = PartOfLevel(id: nil, part: partOfLevelDTO.part, levelID: currentLevelID)
        try await partOfLevel.save(on: req.db)
        
        return try await partOfLevel.toDTO(req: req)
    }
}
