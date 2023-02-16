//
//  DataManager.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/13/22.
//

// sources
// https://www.youtube.com/watch?v=6b2WAePdiqA

import Foundation
import Firebase

class DataManager: ObservableObject {
    @Published var albums: [Album] = []
//    @Published var albumIds: [String] = []
//    @Published var genres: [String : Int] = [:]
     @Published var genres: [String] = ["Pop", "Hip-Hop/Rap", "Indie", "Alternative", "Indie Pop", "Rock", "Classical", "Latin", "EDM", "R&B", "Country", "Holiday", "Disco", "Metal", "Jazz", "Soul", "Folk", "Film"]
    
    @Published var reviews: [Review] = []
    @Published var averageReview: Float = -1

    
    init() {
        fetchAlbums()
        // catalogueAlbums()
    }
    
    func fetchAlbums() {
        albums.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Albums")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let image = data["image_address"] as? String ?? ""
                    let artist = data["artist"] as? String ?? ""
                    let releaseString = data["release_date"] as? String ?? ""
                    let release = self.dateFormatter(date: releaseString)
                    // let duration = data["duration"] as? String ?? ""
                    let genre = data["genre"] as? String ?? ""
                    let songs = data["num_songs"] as? String ?? ""
                    
                    let album = Album(id: id, name: name, image: image, artist: artist, release: release, songs: songs, genre: genre)
                    self.albums.append(album)
                }
            }
        }
    }
    
    func dateFormatter(date: String) -> Date {
        let getFormatter = ISO8601DateFormatter()
        return getFormatter.date(from: date) ?? Date(timeIntervalSinceNow: 0)
    }
    
//    func catalogueAlbums() {
//        for album in albums {
//            if !self.albumIds.contains(album.id) {
//                self.albumIds.append(album.id)
//            }
//            self.genres[album.genre, default: 0] += 1
//        }
//    }
    
    func addAlbum(albumName: String, id: String, artist: String, imageAddr: String, songs: String, release: Date, genre: String) {
        
        let dateFormatter = ISO8601DateFormatter()
        let releaseString = dateFormatter.string(from: release)
        
        
        let db = Firestore.firestore()
        let ref = db.collection("Albums").document(id)
        ref.setData(["name": albumName, "id": id, "artist": artist, "genre": genre, "image_address": imageAddr, "release_date": releaseString, "num_songs": songs]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func addAlbum(album: Album) {
        
        let dateFormatter = ISO8601DateFormatter()
        let releaseString = dateFormatter.string(from: album.release)
        
        let db = Firestore.firestore()
        let ref = db.collection("Albums").document(album.id)
        ref.setData(["name": album.name, "id": album.id, "artist": album.artist, "genre": album.genre, "image_address": album.image, "release_date": releaseString, "num_songs": album.songs]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func getRandomAlbum() -> Album {
        return albums.randomElement() ?? Album(id: "slhfelih2wihi3h", name: "Dummy Album", image: "https://www.tvguide.com/a/img/hub/2020/04/16/4fbb4e49-ec25-473e-b1de-58f9cbab3589/dummy-reg.jpg", artist: "Silly Goose", release: Date(timeIntervalSince1970: 2000000), songs: "12", genre: "Indie")
    }
    
//    func calculateReviews() {
//        for album in albums {
//
//            var sum: Float = -1
//            var numReviews: Int = 0
//
//            let db = Firestore.firestore()
//            let ref = db.collection("Albums/\(album.id)/reviews")
//            ref.getDocuments { snapshot, error in
//                guard error == nil else {
//                    print(error!)
//                    return
//                }
//                if let snapshot = snapshot {
//                    for document in snapshot.documents {
//                        let data = document.data()
//                        let rating = data["rating"] as? Int ?? 0
//                        numReviews += 1
//                        sum += Float(rating)
//                    }
//                }
//                else  {
//                    print("Issue getting snapshot of documents") // seems good
//                }
//            }
//
//            if numReviews > 0 {
//                album.avgRating = sum/Float(numReviews)
//                album.reviews = numReviews
//            }
//        }
//    }
    
    func fetchReviewsForAlbum(albumId: String) async {
        self.reviews.removeAll()
        self.averageReview = -1
        await fetchReviews(albumId: albumId)
        
        if self.reviews.isEmpty {
            return
        } else {
            var totalScore: Float
            totalScore = 0
            for review in self.reviews {
                totalScore += Float(review.rating)
            }
            self.averageReview = totalScore/Float(self.reviews.count)
            return
        }
    }
    
    func fetchReviews(albumId: String) async {
        let db = Firestore.firestore()
        let ref = db.collection("Albums/\(albumId)/reviews")
        try await ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = document.documentID
                    let username = data["username"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let desc = data["desc"] as? String ?? ""
                    let rating = data["rating"] as? Int ?? 0
                    let reviewedAlbum = data["reviewedAlbum"] as? String ?? ""
                    
//                    let reviewedAlbum = data["reviewedAlbum"] as? String ?? ""
                    let date = (data["postedOn"] as? Timestamp)?.dateValue() ?? Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM dd, yyyy"
                    let postedOn = formatter.string(from: date)

                    let review = Review(id: id, title: title, desc: desc, rating: rating, postedOn: postedOn)
                    // let review = Review(title: title, desc: desc, rating: rating, postedOn: postedOn)
                    self.reviews.append(review)
                }
            }
        }
    }
    
    
    func addReview(id : String, username: String, title: String, desc: String, rating: String, reviewedAlbum: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Reviews").document(id)
        ref.setData(["username": username, "title": title, "desc": desc,  "rating": rating, "reviewedAlbum": reviewedAlbum]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
//    func getAlbum(id: String) {
//        if let self.albums.first(where: {$0.id == id}) {
//
//        }
//    }
}
