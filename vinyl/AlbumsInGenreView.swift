//
//  AlbumsInGenreView.swift
//  vinyl
//
//  Created by Matt Lunsford on 12/9/22.
//

import SwiftUI

struct AlbumsInGenreView: View {
    @EnvironmentObject var dataManager: DataManager
    
    
    let genre: String
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(dataManager.albums, id: \.id) { album in
                        if album.genre == genre {
                            NavigationLink(destination: AlbumDetailView(selectedAlbum: album)) {
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
                }
            }
            .navigationBarTitle(Text(genre))
        }
}

struct AlbumsInGenreView_Previews: PreviewProvider {
    
    static var previews: some View {
        AlbumsInGenreView(genre: "Pop")
            .environmentObject(DataManager())
    }
}
