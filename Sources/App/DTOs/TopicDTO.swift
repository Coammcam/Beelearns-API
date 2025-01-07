//
//  TopicDTO.swift
//  Beelearns-API
//
//  Created by Nguyễn Hưng on 30/12/2024.
//

import Vapor

struct TopicDTO: Content {
    var name: String
    
    func toModel() -> Topic {
        let model = Topic()
        
        model.name = self.name
        
        return model
    }
}
