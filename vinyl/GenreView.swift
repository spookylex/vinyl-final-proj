//
//  GenreView.swift
//  vinyl
//
//  Created by Matt Lunsford on 11/30/22.
//

import SwiftUI

struct GenreView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var contextHolder: ContextHolder
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        let colors = [Color("Pink"), Color("Purple"), Color("Blue"), Color("Green")]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                
//                ForEach(dataManager.genres.sorted(by: >), id: \.key) { genre, count in
                ForEach(dataManager.genres, id: \.self) { genre in
                    NavigationLink(destination: AlbumsInGenreView(genre: genre)) {
                        Text(genre)
//                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(.title3, weight: .regular))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 0, idealWidth: 300, maxWidth: .infinity, minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(colors.randomElement() ?? .black))
                            // .shadow(radius: 3))
                            .padding(.horizontal, 3)
                    }
                }
            }
            // .padding()
        }
    }
}

//extension Color {
//    static let ui = Color.UI()
//
//    struct UI {
//        let customPink = Color("")
//    }
//}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreView()
            .environmentObject(DataManager())
    }
}
