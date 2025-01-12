//
//  PartOfLevelController.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

struct PartOfLevelController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let partOfLevelRoute = routes.grouped("part_of_level")
        partOfLevelRoute.get(":level", use: getPartOfLevelByLevel)
        partOfLevelRoute.post(use: addPartOfLevel)
    }
    
    func getPartOfLevelByLevel(req: Request) async throws -> [PartOfLevelDTO] {
        guard let level = req.parameters.get("level") else { return [] }
        guard let levelNumber = Int(level) else { throw Abort(.badRequest) }
        let partsFromLevel = try await PartOfLevel.query(on: req.db).filter(\.$level == levelNumber).all()
        return partsFromLevel.map({$0.toDTO()})
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
