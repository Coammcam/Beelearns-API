//
//  PodcastController.swift
//
//
//  Created by Nguyễn Hưng on 13/11/2024.
//


import Vapor

struct PodcastController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let poscastsRoute = routes.grouped("podcast")
        
        poscastsRoute.get(use: getPodcasts)
        poscastsRoute.post(use: addPodcast)
        
        poscastsRoute.group(":id") {music in
            music.get(use: getPodcast)
            music.put(use: updatePodcast)
            music.delete(use: deletePodcast)
        }
        
    }
    
    func getPodcasts(req: Request) async throws -> [PodcastDTO] {
        let podcastList = try await Podcast.query(on: req.db).all()
        
        return podcastList.map{ podcast in
            podcast.toDTO()
        }
    }
    
    func getPodcast(req: Request) async throws -> PodcastDTO {
        guard let podcast = try await Podcast.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound, reason: "Podcast not found")
        }
        return podcast.toDTO()
    }
    
    func addPodcast(req: Request) async throws -> PodcastDTO {
        let podcastDTO = try req.content.decode(PodcastDTO.self)
        let podcast = podcastDTO.toModel()
        try await podcast.save(on: req.db)
        return podcast.toDTO()
    }
    
    func updatePodcast(req: Request) async throws -> PodcastDTO {
        guard let podcastID = req.parameters.get("id", as: UUID.self),
              let existingPodcast = try await Podcast.find(podcastID, on: req.db) else {
            throw Abort(.notFound, reason: "Podcast not found")
        }
        
        let updatedData = try req.content.decode(PodcastDTO.self)
        
        existingPodcast.title = updatedData.title
        existingPodcast.image_url = updatedData.image_url
        existingPodcast.description = updatedData.description
        existingPodcast.duration = updatedData.duration
        existingPodcast.link_on_youtube = updatedData.link_on_youtube
        
        try await existingPodcast.save(on: req.db)
        
        return existingPodcast.toDTO()
    }
    
    func deletePodcast(req: Request) async throws -> HTTPStatus {
        guard let podcastID = req.parameters.get("id", as: UUID.self),
              let podcast = try await Podcast.find(podcastID, on: req.db) else {
            throw Abort(.notFound, reason: "Podcast not found")
        }
        
        try await podcast.delete(on: req.db)
        
        return .noContent
    }
    
}

