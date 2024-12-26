//
//  PartOfLevelDTO.swift
//
//
//  Created by Nguyễn Hưng on 25/12/2024.
//

import Vapor

struct PartOfLevelDTO: Content {
    var part: Int
    var level_id: Level_difficulty
    
    func toModel(levels: [Level]) -> PartOfLevel? {
        guard let matchingLevel = levels.first(where: {$0.level == self.level_id }) else {
            return nil
        }
        
        return PartOfLevel(id: nil, part: self.part, levelID: matchingLevel.id!)
    }
}
