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
        
        grammarquestions.get("byamount", use: getByAmount)
    }
    
    
    func getByAmount(req: Request) async throws -> [GrammarQuestionDTO] {
        guard var amount: Int = req.query["amount"] else { throw Abort(.badRequest) }
        
        let count = try await GrammarQuestion.query(on: req.db).count()
        
        if(amount <= 0){
            return []
        } else if (amount > count){
            amount = count
        }
        
        let lowerRange = Int.random(in: 0...count-amount)
        let upperRange = lowerRange + amount
        
        let questions = try await GrammarQuestion.query(on: req.db).range(lower: lowerRange, upper: upperRange-1).all()
        
        return questions.map({ question in
            GrammarQuestionDTO(question: question.question, correct_answer: question.correct_answer, meaning: question.meaning, topic: question.topic, level: question.level)
        })
        
    }
    
    
}
