//
//  Review.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/3/22.
// https://www.youtube.com/watch?v=7MJIwXgOtKs&t=368s -- new review layout


import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var reviewer = "" //Auth.auth().currentUser.email - username
    var title = ""
    var desc = ""
    var rating =  0
    var postedOn = ""
    
    var dictionary: [String: Any] {
        return ["title" : title, "desc" : desc, "rating" : rating, "reviewer" : Auth.auth().currentUser?.email ?? "", "postedOn" : Timestamp(date: Date())]
        
    }
    
}
