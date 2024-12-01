//
//  Podcast.swift
//
//
//  Created by Nguyễn Hưng on 13/11/2024.
//

import Vapor
import Fluent

final class Podcast: Model, Content {
    static let schema = "podcast"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "image_url")
    var image_url: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "duration")
    var duration: String
    
    @Field(key: "views")
    var views: String
    
    @Field(key: "link_on_youtube")
    var link_on_youtube: String
    
    @Timestamp(key: "create_at", on: .create)
    var createAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, title: String, image_url: String, description: String, duration: String, views: String ,link_on_youtube: String, createAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.image_url = image_url
        self.description = description
        self.duration = duration
        self.views = views
        self.link_on_youtube = link_on_youtube
        self.createAt = createAt
        self.updatedAt = updatedAt
    }
    
    func toDTO() -> PodcastDTO {
        .init(
            title: self.title,
            image_url: self.image_url,
            description: self.description,
            duration: self.duration,
            views: self.views,
            link_on_youtube: self.link_on_youtube
        )
    }
}
