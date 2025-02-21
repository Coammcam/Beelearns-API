//
//  TrueFalseQuestionController.swift
//
//
//  Created by HoangDus on 31/10/2024.
//

import Foundation
import Vapor
import Fluent

struct TrueFalseQuestionController: RouteCollection{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let trueFalseQuestions = routes.grouped("truefalse")
        trueFalseQuestions.get(":level", use: getQuestionByLevelAndLevel)
        
        trueFalseQuestions.group(":id") { truefalse in
            truefalse.delete(use: deleteByID)
            truefalse.put(use: updateByID)
        }
    }
    
    func getQuestionByLevelAndLevel(req: Request) async throws -> [TrueFalseQuestionDTO]{
        guard let level = req.parameters.get("level") else { return [] }
        
        guard let levelNumber = Int(level) else { throw Abort(.badRequest) }
        
        guard let amount: Int = req.query["amount"] else {
            let questions = try await TrueFalseQuestion.query(on: req.db).all()
            return questions.map({ question in question.toDTO() })
        }
        
//        if(amount < 0){
//            let questions = try await TrueFalseQuestion.query(on: req.db).all()
//            return questions.map({ question in question.toDTO() })
//        }
        
        let questions = try await TrueFalseQuestion.query(on: req.db).filter(\.$level == levelNumber).all().randomSample(count: amount)
        return questions.map({ question in question.toDTO() })
    }
    
    func deleteByID(req: Request) async throws -> HTTPStatus{
        guard let deletedTrueFalse = try await TrueFalseQuestion.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await deletedTrueFalse.delete(on: req.db)
        return .ok
    }
    
    func updateByID(req: Request) async throws -> TrueFalseQuestionDTO {
        guard let truefalse = try await TrueFalseQuestion.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        
        let updatetruefalse = try req.content.decode(TrueFalseQuestionDTO.self)
        
        truefalse.content = updatetruefalse.content ?? ""
        truefalse.vietnameseMeaning = updatetruefalse.vietnameseMeaning ?? ""
        truefalse.answer = updatetruefalse.answer ?? ""
        truefalse.correction = updatetruefalse.correction ?? ""
        truefalse.topic = updatetruefalse.topic ?? ""
        truefalse.level = updatetruefalse.level ?? 0
        
        try await truefalse.save(on: req.db)
        
        return updatetruefalse
    }
    
}
