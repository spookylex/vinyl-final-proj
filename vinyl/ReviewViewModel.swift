//
//  ReviewViewModel.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/11/22.
// https://www.youtube.com/watch?v=t3RzASKWZes&t=496s

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject{
    
    @Published var review = Review()
    
    func saveReview(album: Album, review: Review) async -> Bool{
        let db = Firestore.firestore()
//
//        guard let albumID = album.id else {
//            print("😭 ERROR: album.id = nil")
//            return false
//        }
        
        let collectionString = "Albums/\(album.id)/reviews"
        
        if let id = review.id{
            do{
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                    print("🥳 Data updated successfully!")
                    return true
            } catch{
                print("🤬 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
        else{
            do{
                _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("🤩 Review added successfully!")
                return true
            } catch {
                print("😰 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }

}
