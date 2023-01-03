//
//  Song.swift
//  
/// represent the data that is in the table
//
//  Created by 耶啵的小头盔 on 12/27/22.
//

import Fluent
import Vapor

//query the data from database
final class Song: Model, Content {
    static let schema = "songs" //songs table
    
    // telling fluent that this property of ID
    // matches the ID property within our table
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    init() {}
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
