//
//  Album.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/13/22.
//

import Foundation

struct Album: Identifiable {
    var id: String
    var name: String
    var image: String
    var artist: String
    var release: Date
    var songs: String
    // var duration: String
    var genre: String
    var reviews: Int?
    var avgRating: Float?
}
