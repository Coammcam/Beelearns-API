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
        levelRoute.get(use: getAllLevels)
        levelRoute.post(use: addLevel)
    }
    
    func getAllLevels(req: Request) async throws -> [LevelDTO]{
        let levels = try await Level.query(on: req.db).all()
        return levels.map({$0.toDTO()})
    }
    
    func addLevel(req: Request) async throws -> LevelDTO {
        let levelDTO = try req.content.decode(LevelDTO.self)
        let level = levelDTO.toModel()
        try await level.save(on: req.db)
        return level.toDTO()
    }
}
