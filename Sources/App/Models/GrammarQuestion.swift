//
//  File.swift
//  
//
//  Created by Nguyễn Hưng on 31/10/2024.
//

import Vapor
import Fluent

final class GrammarQuestion: Model, Content {
    static let schema = "grammar-questions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "question")
    var question: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "meaning")
    var meaning: String
    
    @Field(key: "topic")
    var topic: String
    
    @Field(key: "level")
    var level: Int
    
    @Timestamp(key: "create_at", on: .create)
    var createAt: Date?
    
    @Timestamp(key: "update_at", on: .update)
    var updateAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, question: String, content: String, meaning: String, topic: String, level: Int) {
        self.id = id
        self.question = question
        self.content = content
        self.meaning = meaning
        self.topic = topic
        self.level = level
    }
    
    func toDTO() -> GrammarQuestionDTO {
        .init(
            question: self.question,
            content: self.content,
            meaning: self.meaning,
            topic: self.topic,
            level: self.level
        )
    }
}
