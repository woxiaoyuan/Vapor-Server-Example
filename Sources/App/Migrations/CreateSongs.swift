//
//  CreateSongs.swift
//
/// Migrations use as GET, tracking changes
//  
//
//  Created by 耶啵的小头盔 on 12/27/22.
//

import Fluent

struct CreateSongs: Migration {
    // the changes we want to make
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        //create the tables
        return database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    // revert the changes
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
    
    
}
