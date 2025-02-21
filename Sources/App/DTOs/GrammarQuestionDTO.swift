//
//  File.swift
//
//
//  Created by Nguyễn Hưng on 01/11/2024.
//

import Vapor

struct GrammarQuestionDTO: Content {
    var question: String
    var content: String
    var meaning: String
    var topic: String
    var level: Int
    
    func toModel() -> GrammarQuestion {
        let model = GrammarQuestion()
        
        model.question = self.question
        model.content = self.content
        model.meaning = self.meaning
        model.topic = self.topic
        model.level = self.level
        
        return model
    }
}
