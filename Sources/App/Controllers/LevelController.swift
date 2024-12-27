//
//  LevelController.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor
import Fluent

struct LevelController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let levelRoute = routes.grouped("level")
        
        levelRoute.post(use: addLevel)
    }
    
    func addLevel(req: Request) async throws -> LevelDTO {
        let levelDTO = try req.content.decode(LevelDTO.self)
        let level = levelDTO.toModel()
        try await level.save(on: req.db)
        return level.toDTO()
    }
}
