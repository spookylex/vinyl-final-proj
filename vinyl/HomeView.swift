//
//  ContentView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/9/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var contextHolder: ContextHolder
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Recent releases")
                        .font(.system(.title2, weight: .bold))
                    
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        LazyHStack {
                            ForEach(dataManager.albums.sorted(by: { $0.release > $1.release }), id: \.id) { album in
                                NavigationLink(destination: AlbumDetailView(selectedAlbum: album).environmentObject(contextHolder)) {
                                    VStack(alignment: .leading) {
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
                                        Spacer(minLength: 10)
                                        Text(album.name)
                                            .font(.system(.footnote, weight: .medium))
                                            .lineLimit(1)
                                        Spacer(minLength: 3)
                                        Text(album.artist)
                                            .font(.system(.caption, weight: .light))
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160, height: 200)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    })
                    
                    Spacer(minLength: 25)
                    
                    Text("All catalogued albums")
                        .font(.system(.title2, weight: .bold))
                    
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        LazyHStack {
                            ForEach(dataManager.albums.sorted(by: { $0.name < $1.name }), id: \.id) { album in
                                NavigationLink(destination: AlbumDetailView(selectedAlbum: album).environmentObject(dataManager)) {
                                    VStack(alignment: .leading) {
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
                                        Spacer(minLength: 10)
                                        Text(album.name)
                                            .font(.system(.footnote, weight: .medium))
                                            .lineLimit(1)
                                        Spacer(minLength: 3)
                                        Text(album.artist)
                                            .font(.system(.caption, weight: .light))
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160, height: 200)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    })
                    
                    Spacer(minLength: 25)
                    
                    Text("Genres")
                        .font(.system(.title, weight: .bold))
                    
                    GenreView()
                }
            }
            .padding()
//            .navigationBarItems(trailing: Button(action: {
//                            showPopup.toggle()
//                        }, label: {
//                            Image(systemName: "plus")
//                        }))
            .navigationTitle("Home")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
//    func dateFormatter(date: String) -> String {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "MMMM dd, yyyy"
//        let storedDate = dateFormatterGet.date(from: date) ?? Date(timeIntervalSinceNow: 0)
//
//        let dateFormatterReturn = DateFormatter()
//        dateFormatterReturn.dateFormat = "dd/mm/yyyy"
//        return dateFormatterReturn.string(from: storedDate)
//    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView()
            .environmentObject(DataManager())
    }
}
