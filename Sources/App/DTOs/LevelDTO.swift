//
//  LevelDTO.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor

struct LevelDTO: Content {
    var level: Int
    
    func toModel() -> Level {
        let model = Level()
        
        model.level = self.level
        
        return model
    }
}
