//
//  Songs.swift
//  App
//
//  Created by 冀卓疌 on 20-07-10.
//

import Vapor

/// The structure for returning songs in a response, as defined by the API documentation.
struct Songs: Equatable, Codable {
    
    init(results: [Song] = []) {
        self.results = results
    }
    
    /// The songs.
    private var results: [Song]
    
}

// MARK: - Content Conformance

// Allows `Songs` to be encoded to and decoded from HTTP messages.
extension Songs: Content { }

// MARK: - Collection Conformance

// Separate `Collection` from `RangeReplaceableCollection` conformance, so the layout is neater.

extension Songs: Collection {
    
    typealias Element = Song
    
    typealias Index = Array<Element>.Index
    
    var startIndex: Index { results.startIndex }
    
    var endIndex: Index { results.endIndex }
    
    func index(after position: Index) -> Index {
        results.index(after: position)
    }
    
    subscript(position: Index) -> Song {
        get { results[position] }
        set(newResult) { results[position] = newResult }
    }
    
}

// MARK: - RangeReplaceableCollection Conformance

// Need `RangeReplaceableCollection` conformance to do things like `songs.append(newSong)`.

extension Songs: RangeReplaceableCollection {

    init() { results = [] }

    mutating func replaceSubrange<C: Collection>(_ subrange: Range<Index>, with newSongs: C) where C.Element == Element {
        results.replaceSubrange(subrange, with: newSongs)
    }

}
