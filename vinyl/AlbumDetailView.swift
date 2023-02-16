//
//  AlbumDetailView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/27/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct AlbumDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contextHolder: ContextHolder
    @Environment(\.managedObjectContext) private var viewContext

    
    @State var selectedAlbum: Album
    var previewRunning = false
    
    //adding capability to save a review to a specific album -- collection Path: "Albums/\(album.id)/reviews"
    @FirestoreQuery(collectionPath: "Albums") var reviews: [Review]
    @State private var showReviewViewSheet = false

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {

                    HStack(alignment: .bottom, spacing: 14) {
                        // album art, name, artist
                        AsyncImage(url: URL(string: selectedAlbum.image)) { phase in
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
                            .frame(minWidth: 0, maxWidth: .infinity)
                        // name and artist
                        VStack(alignment: .leading, spacing: 5) {
                            Text(selectedAlbum.name)
                                .font(.system(.headline))
                                .lineLimit(3)
                            Text(selectedAlbum.artist)
                                .font(.system(.subheadline))
                                .lineLimit(1)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    Section{
                        HStack(spacing: 35) {
                            Text(formatDateToString(date: selectedAlbum.release))
                                .font(.system(.footnote, weight: .thin))
                            Text(selectedAlbum.songs)
                                .font(.system(.footnote, weight: .thin))
                            + Text(" songs")
                                .font(.system(.footnote, weight: .thin))
                            Text(selectedAlbum.genre)
                                .font(.system(.footnote, weight: .thin))
                            
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 15)
                    Divider()
                        // List {
                            Section { //display the saved reviews
                                ForEach(dataManager.reviews) { review in
                                    NavigationLink {
                                        NewReviewView(album: selectedAlbum, review: review)
                                            .environmentObject(contextHolder)
                                    } label: {
                                        ReviewCellView(review: review)
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 8)
                                    }
                                    .buttonStyle(.plain)
                                }
                            } header: {
                                HStack{
                                                                   if dataManager.reviews.isEmpty {
                                                                       Text("No reviews yet!")
                                                                           .font(.title3)
                                                                           .bold()
                                                                       Spacer()
                                                                       Button("Write a Review"){
                                                                           showReviewViewSheet.toggle()
                                                                       }
                                                                       .foregroundColor(.black)
                                                                       .buttonStyle(.borderedProminent)
                                                                       .bold()
                                                                       .tint(Color("Green"))
                                                                   } else {
                                                                       Text("Avg. Rating: ")
                                                                           .font(.title2)
                                                                           .bold()
                                                                       Text(String(Float(round(10 * avgReviews(reviews: dataManager.reviews)) / 10)))
                                                                           . font(.title3)
                                                                           .fontWeight(.black)
                                                                           .foregroundColor(.blue)
                                                                       Spacer()
                                                                       Button("Write a Review"){
                                                                           showReviewViewSheet.toggle()
                                                                       }
                                                                       .foregroundColor(.black)
                                                                       .buttonStyle(.borderedProminent)
                                                                       .bold()
                                                                       .tint(Color("Green"))
                                                                   }
                                                               }
                                                           }
                                                       .headerProminence(.increased)
//                    }
//                        .listStyle(.plain)
            } // vstack
        } //navigation view
        .padding()
        .navigationTitle(selectedAlbum.name)
        .sheet(isPresented: $showReviewViewSheet){
            NavigationStack{
                NewReviewView(album: selectedAlbum, review: Review())
            }
        }
        .task{
            if !previewRunning{
                $reviews.path = "Albums/\(selectedAlbum.id )/reviews"
                //$reviews.path = "Albums/\(album.id ?? "" )/reviews"
                print("reviews.path = \($reviews.path)")
                // dataManager.fetchReviews(albumId: selectedAlbum.id)
                await dataManager.fetchReviewsForAlbum(albumId: selectedAlbum.id)
            }
        }
//                        async {
//                            await dataManager.fetchReviews(albumId: selectedAlbum.id)
//                        }
        }
    func avgReviews(reviews: [Review]) -> Float {
        if reviews.count == 0 {
            return -1
        } else {
            var rating: Float = 0
            for review in reviews {
                rating += Float(review.rating)
            }
            return rating/Float(reviews.count)
        }
    }
    
    func formatDateToString(date: Date) -> String {
        let dateFormatterReturn = DateFormatter()
        dateFormatterReturn.dateFormat = "MMMM dd, yyyy"
        return dateFormatterReturn.string(from: date)
    }
}
       


struct AlbumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
                   AlbumDetailView(selectedAlbum: Album(id: "1000", name: "The Fame Monster", image: "https://cdn.albumoftheyear.org/album/the-fame-monster-1.jpg", artist: "Lady Gaga", release: Date(timeIntervalSince1970: 200000), songs: "23", genre: "Pop"), previewRunning: true)
               }
    }
}
