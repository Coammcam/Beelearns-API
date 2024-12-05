//
//  QuestionController.swift
//
//
//  Created by Nguyễn Hưng on 18/11/2024.
//

import Vapor
import Fluent

struct QuestionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let questions = routes.grouped("questions")
        questions.get(use: getRandomQuestion)
    }
    
    func getRandomQuestion(req: Request) async throws -> CombinedQuestionDTO {
        guard let total: Int = req.query["total"], total > 0 else {
            throw Abort(.badRequest, reason: "Invalid total number of questions")
        }
        
        let firstHalf = floor(Double(total) * 0.6)
        let secondHalf = Double(total) - firstHalf
        let excess = Double(total) - (firstHalf + (floor(secondHalf / 2)*2))
        
        let grammarAmount = Int(firstHalf + excess)
        let wordAmount = Int(floor(secondHalf / 2))
        let truefalseAmount = Int(floor(secondHalf / 2))
        
        let words = try await Word.query(on: req.db).all().randomSample(count: wordAmount*4).map({$0.toDTO()})
        let trueFalseQuestions = try await TrueFalseQuestion.query(on: req.db).all().randomSample(count: truefalseAmount).map({$0.toDTO()})
        let grammarQuestions = try await GrammarQuestion.query(on: req.db).all().randomSample(count: grammarAmount).map({$0.toDTO()})
        
//        sleep(5)
        return CombinedQuestionDTO(words: words, trueFalseQuestions: trueFalseQuestions, grammarQuestions: grammarQuestions)
    }
}
