//
//  PlaylistMigration.swift
//  App
//
//  Created by 冀卓疌 on 20-07-09.
//

import Vapor
import FluentPostgreSQL

// Allow `Playlist` to be used as a dynamic migration.
extension Playlist: Migration { }
