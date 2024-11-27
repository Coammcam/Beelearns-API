//
//  TrueFalseQuestion.swift
//  
//
//  Created by HoangDus on 31/10/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

final class TrueFalseQuestion: Model{
    static let schema: String = "true_false_questions"
    
    @ID(custom: .id)
    var id: ObjectId?
    @Field(key: "content")
    var content: String
    @Field(key: "answer")
    var answer: String
    @Field(key: "vietnamese_meaning")
    var vietnameseMeaning: String
    @Field(key: "correction")
    var correction: String?
    @Field(key: "topic")
    var topic: String?
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: ObjectId? = nil, content: String, answer: String, vietnameseMeaning: String, correction: String? = nil, topic: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.content = content
        self.answer = answer
        self.vietnameseMeaning = vietnameseMeaning
        self.correction = correction
        self.topic = topic
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> TrueFalseQuestionDTO{
        return TrueFalseQuestionDTO(content: content, vietnameseMeaning: vietnameseMeaning, answer: answer, correction: correction, topic: topic)
    }
}
