//
//  NewReviewView.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/3/22.
// https://www.youtube.com/watch?v=7MJIwXgOtKs&t=368s -- new review layout

import Foundation
import SwiftUI
import Firebase
import CoreData


struct NewReviewView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var rev: Item? //the current item
    @State var album: Album // spot
    @State var review: Review
    @StateObject var reviewVM = ReviewViewModel()
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject var dataManager: DataManager
    
    @State private var id = ""
    @State private var username = "" //pull from user UID ?
    @State private var title = ""
    @State private var desc = ""
    @State private var rating = 0
    @State private var reviewedAlbum = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer(minLength: 16)
                HStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: album.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Color.red // Indicates an error.
                        } else {
                            Color.blue // Acts as a placeholder.
                        }
                    }
                    .frame(maxWidth: 80, maxHeight: 80)
                    VStack(alignment: .leading){
                        Text(album.name)
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.leading )
                            .lineLimit(1)
                        Text(album.artist)
                            .font(.callout)
                    }
                    // .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            VStack(alignment: .leading) {
                Divider()
                Spacer(minLength: 16)
                Text("Rate")
                    .font(.title2)
                    .bold()
                Spacer(minLength: 6)
                HStack(spacing: 6){
                    StarSelectionView(rating: $review.rating)
                }
                
                Spacer(minLength: 25)
                VStack(alignment: .leading){
                    Text("Add a title")
                        .bold()
                    
                    TextField("Title", text: $review.title)
                        .textFieldStyle(.roundedBorder)
                    
                    
                    Spacer(minLength: 25)
                    Text("Review")
                        .bold()
                    
                    TextField("Description", text: $review.desc, axis: .vertical) //scrolls vertically if user adds more than what available space is there
                        .textFieldStyle(.roundedBorder)
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                }
                .font(.title2)
                
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Save Draft"){
                        
                        rev = Item(context:  viewContext) //creating a new core data item
                        
                        //                            rev?.reviewer = Auth.auth().currentUser?.email
                        rev?.id = album.id
                        rev?.title = review.title
                        rev?.desc = review.desc
                        rev?.rating = Int32(review.rating)
                        rev?.postedOn = review.postedOn
                        contextHolder.saveContext(viewContext)
                        self.presentationMode.wrappedValue.dismiss()
                        
                        
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Post"){
                        Task{
                            await reviewVM.saveReview(album: album, review: review)
                            await dataManager.fetchReviewsForAlbum(albumId: album.id)
                        }
                        dismiss()
                    }
                }
            }
        }
        }
    }
    


struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            let dataManager = DataManager()
            NewReviewView(album: Album(id: "0", name: "An Evening with Silk Sonic", image: "https://media.pitchfork.com/photos/618a3190a06d7bd133209ff8/3:2/w_1425,h_950,c_limit/100000x100000-999.jpeg", artist: "Silk Sonic", release: Date(), songs: "Silk Sonic Intro", genre: "R&B"), review: Review())
                .environmentObject(dataManager)

        }
    }
}
