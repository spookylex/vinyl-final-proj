//
//  AlbumList.swift
//  vinyl
//
//  Created by Matt Lunsford on 12/3/22.
//

// source
// https://www.youtube.com/watch?v=UQHqFIx7WnY

import Foundation
import Combine

// sample URL call
// https://itunes.apple.com/search?term=charli+xcx&entity=album&limit=5

class AlbumListViewModel: ObservableObject {
    
    @Published var searchTerm: String = ""
    @Published var albums: [AlbumResult] = [AlbumResult]()
    
    let limit: Int = 20
    
    var subscriptions = Set<AnyCancellable>()
    
//    init() {
//        $searchTerm
//            .dropFirst()
//            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
//            .sink { [weak self] term in
//            self?.fetchAlbms(for: term)
//        }.store(in: &subscriptions)
//    }
    
        func fetchAlbums(for searchTerm: String) async {
            // guard let url = URL(string: // "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=\(limit)") else {
            guard let url = createURL(for: searchTerm) else {
                print("invalid URL")
                return // if we've failed to create a valid URL, return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url) // return value of the url is going to be a tuple, but we are tossing the second part (the underscore)
    
                do {
                    let decodedResponse = try JSONDecoder().decode(SearchResult.self, from: data)
                    self.albums = decodedResponse.results
                } catch {
                    print(error)
                }
            } catch {
                print("invalid data")
            }
        }
    
    func createURL(for searchTerm: String) -> URL? {
        
        let baseURL = "https://itunes.apple.com/search"
        
        let queryItems = [URLQueryItem(name: "term", value: searchTerm),
                          URLQueryItem(name: "entity", value: "album"),
                          URLQueryItem(name: "limit", value: String(limit))]
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        return components?.url
    }
}

struct SearchResult: Codable {
    let resultCount: Int
    var results: [AlbumResult]
}

struct AlbumResult: Codable, Identifiable {
    let collectionType: CollectionType
    let id: Int // orginally "collectionID"
    let artistID: Int
    let amgArtistID: Int?
    let artistName, collectionName: String
    let artworkUrl60, artworkUrl100: String
    let trackCount: Int
    let copyright: String
    let country: Country
    let releaseDate: String
    let primaryGenreName: String
    // let primaryGenreName: PrimaryGenreName

    enum CodingKeys: String, CodingKey {
        case collectionType
        case artistID = "artistId"
        case id = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName
        case artworkUrl60, artworkUrl100, trackCount, copyright, country, releaseDate, primaryGenreName
    }
}

enum CollectionType: String, Codable {
    case album = "Album"
}


enum Country: String, Codable {
    case usa = "USA"
}

//enum PrimaryGenreName: String, Codable {
//    case alternative = "Alternative"
//    case dance = "Dance"
//    case downtempo = "Downtempo"
//    case electronic = "Electronic"
//    case hipHopRap = "Hip-Hop/Rap"
//    case pop = "Pop"
//    case holiday = "Holiday"
//    case rock = "Rock"
//    case indie = "Indie"
//    case soundtrack = "Soundtrack"
//    case country = "Counry"
//}

enum WrapperType: String, Codable {
    case collection = "collection"
}
