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
        words.delete("deleteByDate", use: deleteBetweenDate)
        words.get("byamount", use: getByAmount)
//        words.post(use: create)
        
        words.group(":id") { aWord in
//            aWord.get(use: getByID)
            aWord.delete(use: deleteByID)
            aWord.put(use: updateByID)
        }
    }
    
    func getAll(req: Request) async throws -> [WordDTO] {
        let words = try await Word.query(on: req.db).all()
        return words.map{word in
//            WordDTO(id: word.id, englishWord: word.englishWord, vietnameseMeaning: word.vietnameseMeaning)
            WordDTO(englishWord: word.englishWord, vietnameseMeaning: word.vietnameseMeaning)
        }
    }
    
    func getByID(req: Request) async throws -> Word{
        guard let aWord = try await Word.find(req.parameters.get("id"), on: req.db) else{
            throw Abort(.notFound)
        }
        return aWord
    }
    
    // words/byamount?amount=
    func getByAmount(req: Request) async throws -> [WordDTO]{
        guard var amount: Int = req.query["amount"] else { throw Abort(.badRequest) }
        
        let wordCount = try await Word.query(on: req.db).count()
        
        if(amount <= 0){
            return []
        }else if(amount > wordCount){
            amount = wordCount
        }
        
        let lowerRange = Int.random(in: 0...wordCount-amount)
        let upperRange = lowerRange + amount
        
        let words = try await Word.query(on: req.db).range(lower: lowerRange, upper: upperRange-1).all()
        print("word ques: ", words.count)
        
        return words.map({word in WordDTO(englishWord: word.englishWord, vietnameseMeaning: word.vietnameseMeaning)})
    }
    
    func create(req: Request) async throws -> Word{
        let aWord = try req.content.decode(Word.self)
        try await aWord.save(on: req.db)
        return aWord
    }
    
    func updateByID(req: Request) async throws -> WordDTO {
        guard let word = try await Word.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        let updatedWord = try req.content.decode(WordDTO.self)
        
        word.englishWord = updatedWord.englishWord
        word.vietnameseMeaning = updatedWord.vietnameseMeaning
        
        try await word.save(on: req.db)
        
        return updatedWord
    }
    
    func deleteByID(req: Request) async throws -> HTTPStatus{
        guard let deletedWord = try await Word.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await deletedWord.delete(on: req.db)
        return .ok
    }
    
    // words/deleteByDate/?fromDate=yyyy-mm-dd&toDate=yyyy-mm-dd
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
