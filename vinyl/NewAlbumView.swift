//
//  NewAlbumView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/22/22.
//

import SwiftUI

struct NewAlbumView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    
    @State private var id = ""
    @State private var name = ""
    @State private var artist = ""
    @State private var imageAddr = ""
    @State private var songs = ""
    // @State private var duration = ""
    @State private var release = ""
    @State private var genre = ""
    
    var body: some View {
        VStack {
            TextField("Album Name", text: $name)
            TextField("Artist", text: $artist)
            TextField("Image Web Address", text: $imageAddr)
            TextField("Number of Songs", text: $songs)
            // TextField("Duration", text: $duration)
            // TextField("Release Date", text: $release)
            TextField("Genre", text: $genre)
            TextField("ID", text: $id)
            
            Button {
                dataManager.addAlbum(albumName: name, id: id, artist: artist, imageAddr: imageAddr, songs: songs, release: Date(timeIntervalSinceNow: 0), genre: genre)
                dataManager.fetchAlbums()
                dismiss()
            } label: {
                Text("Save")
            }
        }
    }
}

struct NewAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        let dataManager = DataManager()
        return NewAlbumView()
            .environmentObject(dataManager)
    }
}
