//
//  MovieController.swift
//  
//
//  Created by HoangDus on 09/11/2024.
//

import Vapor

struct MovieController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let movies = routes.grouped("movies")
        movies.get(use: getAll)
    }
    
    func getAll(req: Request) async throws -> [MovieDTO]{
        let movies = try await Movie.query(on: req.db).all().map{
            movie in movie.toDTO()
        }
        return movies
    }
}
