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
        trueFalseQuestions.get(use: getAll)
        trueFalseQuestions.get("byamount", use: getByAmount)
        
    }
    
    func getAll(req: Request) async throws -> [TrueFalseQuestionDTO]{
        let questions = try await TrueFalseQuestion.query(on: req.db).all()
        return questions.map({ question in
            TrueFalseQuestionDTO(content: question.content, vietnameseMeaning: question.vietnameseMeaning, answer: question.answer, correction: question.correction, topic: question.topic)
        })
    }
    
    func getByAmount(req: Request) async throws -> [TrueFalseQuestionDTO]{
        guard var amount: Int = req.query["amount"] else { throw Abort(.badRequest) }
        
        let questionCount = try await TrueFalseQuestion.query(on: req.db).count()
        
        if(amount <= 0){
            return []
        }else if(amount > questionCount){
            amount = questionCount
        }
        
        let lowerRange = Int.random(in: 0...questionCount-amount)
        let upperRange = lowerRange + amount
        
        let questions = try await TrueFalseQuestion.query(on: req.db).range(lower: lowerRange, upper: upperRange-1).all()
//        print(questions.count)
        
        return questions.map({ question in
            TrueFalseQuestionDTO(content: question.content, vietnameseMeaning: question.vietnameseMeaning, answer: question.answer, correction: question.correction, topic: question.topic)
        })
    }
}
