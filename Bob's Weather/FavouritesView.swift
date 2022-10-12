//
//  FavouritesView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/9/22.
//

import SwiftUI

struct FavouritesView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(3 / 2, contentMode: .fit)
            .overlay(TextOverlay())
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight, .topRight])
    }
}

struct TextOverlay: View {
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.8), .black.opacity(0.2)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                gradient
                VStack(alignment: .trailing) {
                    Text("Your Location")
                        .font(.caption)
                        .fontWeight(.thin)
                    
                    Text(LocationViewModel.shared.currentPlacemark?.locality ?? "Could not detect location")
                        .font(.title)
                        .fontWeight(.light)
                    Text(LocationViewModel.shared.currentPlacemark?.country ?? "Could not detect location")
                        .font(.body)
                        .fontWeight(.light)
                    
                    Spacer()
                    
                    Text("Favourites")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                }
                .padding()
            }
            .foregroundColor(.white)
            
            
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(imageName: "desert")
    }
}
