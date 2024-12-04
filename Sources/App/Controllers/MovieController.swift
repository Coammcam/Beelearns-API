//
//  MovieController.swift
//  
//
//  Created by HoangDus on 09/11/2024.
//

import Vapor
import Fluent

struct MovieController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let movies = routes.grouped("movies")
        movies.get(use: getAll)
        movies.post(use: addMovie)
        
        movies.group(":id") { movie in
            movie.delete(use: deleteByID)
            movie.put(use: updateByID)
        }
    }
    
    func getAll(req: Request) async throws -> [MovieDTO]{
        let movies = try await Movie.query(on: req.db).all().map{
            movie in movie.toDTO()
        }
        return movies
    }
    
    func deleteByID(req: Request) async throws -> HTTPStatus {
        guard let deleteMovie = try await Movie.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        try await deleteMovie.delete(on: req.db)
        return .ok
    }
    
    func updateByID(req: Request) async throws -> MovieDTO {
        guard var movie = try await Movie.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        let updateMovie = try req.content.decode(MovieDTO.self)
        
        movie.title = updateMovie.title ?? ""
        movie.banner = updateMovie.banner ?? ""
        movie.poster = updateMovie.poster ?? ""
        movie.description = updateMovie.description ?? ""
        movie.duration = updateMovie.duration ?? ""
        movie.genre = updateMovie.genre ?? ""
        movie.rating = updateMovie.rating ?? ""
        movie.year = updateMovie.year ?? ""
        movie.trailer = updateMovie.trailer ?? ""
        
        try await movie.save(on: req.db)
        
        return updateMovie
    }
    
    func addMovie(req: Request) async throws -> MovieDTO {
        let movieDTO = try req.content.decode(MovieDTO.self)
        let movie = movieDTO.toModel()
        
        try await movie.save(on: req.db)
        
        return movie.toDTO()
    }
    
}
