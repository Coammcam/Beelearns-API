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
        
        guard (try await Level.query(on: req.db)
            .filter(\.$level == partOfLevelDTO.level)
            .first()) != nil
        else {
            throw Abort(.notFound, reason: "Level \(partOfLevelDTO.level) does not exist.")
        }
        
        // Get the highest level in the database
        let highestLevel = try await Level.query(on: req.db)
            .sort(\.$level, .descending)
            .first()?.level ?? 0
        
        // Validate that the level is not lower than the current highest level
        if partOfLevelDTO.level < highestLevel {
            throw Abort(.badRequest, reason: "Cannot add part to Level \(partOfLevelDTO.level) because there are parts in higher levels.")
        }
        
        let partOfLevel = partOfLevelDTO.toModel()
        try await partOfLevel.save(on: req.db)
        
        return partOfLevel.toDTO()
    }
}
