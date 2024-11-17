//
//  MusicController.swift
//
//
//  Created by Nguyễn Hưng on 13/11/2024.
//

import Vapor

struct MusicController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let musicsRoute = routes.grouped("music")
        
        musicsRoute.get(use: getMusics)
        musicsRoute.post(use: addMusic)
        
        musicsRoute.group(":id") {music in
            music.get(use: getMusic)
            music.put(use: updateMusic)
            music.delete(use: deleteMusic)
        }
        
    }
    
    func getMusics(req: Request) async throws -> [MusicDTO] {
        let musicList = try await Music.query(on: req.db).all()
        
        return musicList.map{ music in
            music.toDTO()
        }
    }
    
    func getMusic(req: Request) async throws -> MusicDTO {
        guard let music = try await Music.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Music not found")
        }
        return music.toDTO()
    }
    
    func addMusic(req: Request) async throws -> MusicDTO {
        let musicDTO = try req.content.decode(MusicDTO.self)
        let music = musicDTO.toModel()
        try await music.save(on: req.db)
        return music.toDTO()
    }
    
    func updateMusic(req: Request) async throws -> MusicDTO {
        guard let musicID = req.parameters.get("id", as: UUID.self),
              let existingMusic = try await Music.find(musicID, on: req.db) else {
            throw Abort(.notFound, reason: "Music not found")
        }
        
        let updatedData = try req.content.decode(MusicDTO.self)
        
        existingMusic.title = updatedData.title
        existingMusic.image_url = updatedData.image_url
        existingMusic.description = updatedData.description
        existingMusic.duration = updatedData.duration
        existingMusic.link_on_youtube = updatedData.link_on_youtube
        
        try await existingMusic.save(on: req.db)
        
        return existingMusic.toDTO()
    }
    
    func deleteMusic(req: Request) async throws -> HTTPStatus {
        guard let musicID = req.parameters.get("id", as: UUID.self),
              let music = try await Music.find(musicID, on: req.db) else {
            throw Abort(.notFound, reason: "Music not found")
        }
        
        try await music.delete(on: req.db)
        
        return .noContent
    }
    
}
