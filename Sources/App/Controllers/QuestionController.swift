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
        
        print(firstHalf)
        
        let grammarAmount = Int(firstHalf + excess)
        let wordAmount = Int(floor(secondHalf / 2))
        let truefalseAmount = Int(floor(secondHalf / 2))
        
        async let words = try WordController().getByAmount(req: req.withQuery("amount", value: "\(wordAmount)"))
        async let truefalseQuestions = try TrueFalseQuestionController().getByAmount(req: req.withQuery("amount", value: "\(truefalseAmount)"))
        async let grammarQuestions = try GrammarQuestionController().getByAmount(req: req.withQuery("amount", value: "\(grammarAmount)"))
        
        let wordsResult = try await words
        let truefalseResult = try await truefalseQuestions
        let grammarResult = try await grammarQuestions
        
        return CombinedQuestionDTO(
            words: wordsResult, trueFalseQuestions: truefalseResult, grammarQuestions: grammarResult)
        
    }
}
