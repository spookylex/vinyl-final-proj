//
//  SearchView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/27/22.
//

// source
// https://www.youtube.com/watch?v=UQHqFIx7WnY

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @StateObject var viewModel = AlbumListViewModel()
    @State var searchText: String = ""
    @State private var showSheet = false
    @State var selectedAlbum: Album?
    @State private var path = NavigationPath()
    // @State private var results = [AlbumResult]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(viewModel.albums, id: \.id) { album in
                Button {
                    selectedAlbum = Album(id: String(album.id), name: album.collectionName, image: album.artworkUrl100, artist: album.artistName, release: dateFormatter(date: album.releaseDate), songs: String(album.trackCount), genre: album.primaryGenreName)
                    
                    if dataManager.albums.contains(where: { $0.id == String(album.id) }) {
                        path.append("AlbumDetailView")
                    } else {
                        dataManager.addAlbum(album: Album(id: String(album.id), name: album.collectionName, image: album.artworkUrl100, artist: album.artistName, release: dateFormatter(date: album.releaseDate), songs: String(album.trackCount), genre: album.primaryGenreName))
                        dataManager.fetchAlbums()
                        // everything above works correctly, but search is bringing up wrong album in AlbumDetailView
                        path.append("AlbumDetailView")
                    }
                } label: {
                    HStack(alignment: .center, spacing: 14) {
                        AsyncImage(url: URL(string: album.artworkUrl60)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(album.collectionName)
                                .font(.system(.footnote, weight: .medium))
                                .lineLimit(1)
                            Text(album.artistName)
                                .font(.system(.footnote))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationDestination(for: String.self) { view in
                    if view == "AlbumDetailView" {
                        AlbumDetailView(selectedAlbum: selectedAlbum ?? Album(id: String(album.id), name: album.collectionName, image: album.artworkUrl100, artist: album.artistName, release: dateFormatter(date: album.releaseDate), songs: String(album.trackCount), genre: album.primaryGenreName))
                        }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                async {
                    if !newValue.isEmpty && newValue.count > 3 {
                        await viewModel.fetchAlbums(for: newValue)
                    } else {
                        viewModel.albums.removeAll()
                    }
                }
            }
            .navigationTitle("Search for an album")
        }
//        .sheet(isPresented: $showSheet) {
//            SearchedAlbumDetailView(searchedAlbum: selectedAlbum ?? Album(id: "???????", name: "loading", image: "", artist: "???", release: "????", songs: "?", genre: "????"))
//        }
    }
    
//    func dateFormatter(date: String) -> String {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let storedDate = dateFormatterGet.date(from: date) ?? Date(timeIntervalSinceNow: 0)
//
//        let dateFormatterReturn = DateFormatter()
//        dateFormatterReturn.dateFormat = "MMMM dd, yyyy"
//        return dateFormatterReturn.string(from: storedDate)
//    }
    
    func dateFormatter(date: String) -> Date {
        let getFormatter = ISO8601DateFormatter()
        return getFormatter.date(from: date)!
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        SearchView()
            .environmentObject(dataManager)
    }
}
