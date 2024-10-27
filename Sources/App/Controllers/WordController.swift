//
//  WordController.swift
//  
//
//  Created by HoangDus on 24/10/2024.
//

import Vapor
import Fluent
import Foundation

struct WordController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let words = routes.grouped("words")
        words.get(use: getAll)
        words.post(use: create)
        
        words.group(":id") { aWord in
            aWord.get(use: getByID)
            aWord.delete(use: deleteByID)
            aWord.put(use: updateByID)
        }
        
        words.group("deleteByDate"){ aWord in
            aWord.delete(use: deleteBetweenDate)
        }
    }
    
    func getAll(req: Request) async throws -> [Word]{
        return try await Word.query(on: req.db).all()
    }
    
    func getByID(req: Request) async throws -> Word{
        guard let aWord = try await Word.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        
        return aWord
    }
    
    func create(req: Request) async throws -> Word{
        let aWord = try req.content.decode(Word.self)
        try await aWord.save(on: req.db)
        return aWord
    }
    
    func updateByID(req: Request) async throws -> Word{
        guard var word = try await Word.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        let updatedWord = try req.content.decode(Word.self)
        word = updatedWord
        try await word.save(on: req.db)
        return word
    }
    
    func deleteByID(req: Request) async throws -> HTTPStatus{
        guard let deletedWord = try await Word.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await deletedWord.delete(on: req.db)
        return .ok
    }
    
    // deleteByDate/?fromDate=yyyy-mm-dd&toDate=yyyy-mm-dd
    func deleteBetweenDate(req: Request) async throws -> HTTPStatus{
        guard let fromDateString: String = req.query["fromDate"] else { throw Abort(.badRequest) }
        guard let toDateString: String = req.query["toDate"] else { throw Abort(.badRequest) }
        
        let fromDateISOString: String = "\(fromDateString)T00:00:00+00:00"
        let toDateISOString: String = "\(toDateString)T23:59:59+00:00"
        
        let fromDate = ISO8601DateFormatter().date(from: fromDateISOString)
        let toDate = ISO8601DateFormatter().date(from: toDateISOString)
        
        if(fromDate! > toDate!){
            throw Abort(.badRequest)
        }
        
        let words = try await Word.query(on: req.db).filter(\.$createdAt > fromDate).filter(\.$createdAt < toDate).all()
        try await words.delete(on: req.db)
        return .ok
    }
}
