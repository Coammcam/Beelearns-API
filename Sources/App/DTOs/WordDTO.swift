//
//  WordDTO.swift
//  
//
//  Created by HoangDus on 30/10/2024.
//

import Vapor
import Fluent
import FluentMongoDriver

struct WordDTO: Content{
//    var id: ObjectId?
    var englishWord: String?
    var vietnameseMeaning: String?
    var topic: String
    var level: Int
    
    func toModel() -> Word {
        let model = Word()
        
        model.englishWord = self.englishWord
        model.vietnameseMeaning = self.vietnameseMeaning
        model.topic = self.topic
        model.level = self.level
        
        return model
    }
}
