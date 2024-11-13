//
//  PodcastDTO.swift
//  
//
//  Created by Nguyễn Hưng on 13/11/2024.
//

import Vapor

struct PodcastDTO: Content {
    var title: String
    var image_url: String
    var description: String
    var duration: String
    var link_on_youtube: String
    
    func toModel() -> Podcast {
        let model = Podcast()
        
        model.title = self.title
        model.image_url = self.image_url
        model.description = self.description
        model.duration = self.duration
        model.link_on_youtube = self.link_on_youtube
        
        return model
    }
}

