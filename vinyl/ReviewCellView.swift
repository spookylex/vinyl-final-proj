//
//  ReviewCellView.swift
//  vinyl
//
//  Created by Matt Lunsford on 12/12/22.
//

import SwiftUI

struct ReviewCellView: View {
    
    let review: Review
    
    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            HStack(alignment: .center) {
//                Text(review.title)
//                    .font(.system(.callout, weight: .medium))
//                Spacer()
//                HStack(spacing: 0) {
//                    ForEach(1...5, id: \.self) { number in
//                        showStar(for: number)
//                            .foregroundColor(number <= review.rating ? .black : .gray)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            HStack(alignment: .top, spacing: 12) {
//                Text(review.postedOn)
//                    .font(.system(.footnote, weight: .ultraLight))
//                Text(review.desc)
//                    .font(.system(.footnote, weight: .light))
//                    // .lineLimit(1)
//            }
//        }
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(review.title)
                    .font(.system(.title3, weight: .medium))
                    .lineLimit(2)
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    HStack(spacing: 0) {
                        ForEach(1...5, id: \.self) { number in
                            showStar(for: number)
                                .foregroundColor(number <= review.rating ? .black : .gray)
                        }
                    }
                    Text(review.postedOn)
                        .font(.system(.caption2, weight: .ultraLight))
                }
            }
            .frame(maxWidth: .infinity)
            Text(review.desc)
                .font(.system(.footnote, weight: .light))
            Divider()
        }
//        .frame()
//        .background(RoundedRectangle(cornerRadius: 12)
//            .fill(.clear))
    }
    
    func showStar (for number: Int) -> Image{
        if number > review.rating {
            return Image(systemName: "star")
        }
        else{
            return Image(systemName: "star.fill")
        }
            
    }
}

struct ReviewCellView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewCellView(review: Review(id: "dlkfhsklhd", reviewer: "mateo.lunsford@gmail.com", title: "Very good album!", desc: "I loved the instrumentels. Incredible vocals, as always. Would love to see production go a little harder on the next album, but overall worth the hype.", rating: 4, postedOn: "December 12, 2022"))
    }
}
