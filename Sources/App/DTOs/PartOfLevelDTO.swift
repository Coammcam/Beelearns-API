//
//  PartOfLevelDTO.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor

struct PartOfLevelDTO: Content {
    var part: Int
    var level: Int
    
    func toModel() -> PartOfLevel {
        let model = PartOfLevel()
        
        model.part = self.part
        model.level = self.level
        
        return model
    }
}
