//
//  GrammarQuestionController.swift
//
//
//  Created by Nguyễn Hưng on 01/11/2024.
//

import Foundation
import Vapor
import Fluent

struct GrammarQuestionController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let grammarquestions = routes.grouped("grammarquestions")
        
        grammarquestions.get(":level", use: getByLevelAndAmount)
        
        grammarquestions.group(":id"){ grammar in
            grammar.put(use: updateByID)
            grammar.delete(use: deleteByID)
        }
    }
    
    
    func getByLevelAndAmount(req: Request) async throws -> [GrammarQuestionDTO] {
        guard let level = req.parameters.get("level") else { return [] }
        
        guard let levelNumber = Int(level) else { throw Abort(.badRequest) }
        
        guard let amount: Int = req.query["amount"] else { throw Abort(.badRequest) }
        
        let questions = try await GrammarQuestion.query(on: req.db).filter(\.$level == levelNumber).all().randomSample(count: amount)
        
        return questions.map({ question in
            GrammarQuestionDTO(question: question.question, correct_answer: question.content, meaning: question.meaning, topic: question.topic, level: question.level)
        })
        
    }
    
    func updateByID(req: Request) async throws -> GrammarQuestionDTO {
        guard let grammar = try await GrammarQuestion.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        let updateGrammar = try req.content.decode(GrammarQuestionDTO.self)
        
        grammar.question = updateGrammar.question
        grammar.content = updateGrammar.correct_answer
        grammar.meaning = updateGrammar.meaning
        grammar.topic = updateGrammar.topic
        grammar.level = updateGrammar.level
        
        try await grammar.save(on: req.db)
        
        return updateGrammar
        
    }
    
    func deleteByID(req: Request) async throws -> HTTPStatus {
        guard let grammar = try await GrammarQuestion.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        try await grammar.delete(on: req.db)
        
        return .ok
    }
    
}
