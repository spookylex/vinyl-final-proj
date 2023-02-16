//
//  StarSelectionView.swift
//  vinyl
//
//  Created by Alexis Osipovs on 12/7/22.
//

import SwiftUI

struct StarSelectionView: View {
    
    @Binding var rating: Int // change to @Binding after testing layout
    let highestRating = 5
    let lowestRating = 1
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColor: Color = .blue
    let emptyColor: Color = .gray
    
    var body: some View {
     
        HStack{
            ForEach(lowestRating...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundColor(number <= rating ? fillColor : emptyColor)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(font)
            
            
        }//end of hstack
        
    }
    
    func showStar (for number: Int) -> Image{
        if number > rating{
            return unselected
        }
        else{
            return selected
        }
            
    }
    
    
}

struct StarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StarSelectionView(rating: .constant(4))
    }
}
