//
//  SongController.swift
//  
//
//  Created by 耶啵的小头盔 on 12/27/22.
//

import Fluent
import Vapor

// a collection of different routes and different functionality
struct SongController: RouteCollection {
    //init
    func boot(routes: Vapor.RoutesBuilder) throws {
        let songs = routes.grouped("songs","**")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        
        
        songs.group(":songID") { song in
            song.delete(use: delete)
            song.patch( use: updatePathMethod)
        } 
    }
    
    // GET http://127.0.0.1:8080/songs
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST Request
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    
    //PUT Request /songs routes
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        
        return Song.find(song.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    
    func updatePathMethod(req: Request) async throws -> Song {
        let patch = try req.content.decode(PatchInfo.self)
        
        guard let dbSong = try await Song.find(req.parameters.get("songID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        if let title = patch.title {
            dbSong.title = title
        }
        try await dbSong.save(on: req.db)
        return dbSong
    }
    
    
    
    
    // DELETE Request /songs/id route
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
}


struct PatchInfo: Decodable {
    var title: String?
}
