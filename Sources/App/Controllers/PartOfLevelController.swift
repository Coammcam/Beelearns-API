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
        
        guard let matchingLevel = try await Level.query(on: req.db)
            .filter(\.$level == partOfLevelDTO.level_id)
            .first(), let levelID = matchingLevel.id else {
            throw Abort(.notFound, reason: "Level not found for the provided difficulty.")
        }
        
        let partOfLevel = PartOfLevel(id: nil, part: partOfLevelDTO.part, levelID: levelID)
        try await partOfLevel.save(on: req.db)
        
        return try await partOfLevel.toDTO(req: req)
    }
}
