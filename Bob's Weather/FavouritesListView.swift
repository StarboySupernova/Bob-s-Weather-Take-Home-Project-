//
//  FavouritesListView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/14/22.
//

import SwiftUI

struct FavouritesListView: View {
    @EnvironmentObject var favourites: FavouritesViewModel
    var body: some View {
        Group {
            VStack(spacing: 20) {
                PageView(pages: ImageViewModel().names.map{FavouritesView(imageName: $0)})
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                                
                if favourites.isEmpty() {
                    VStack{
                        Text("You have no favourites yet")
                            .foregroundColor(.white)
                    } 
                } else {
                    ForEach(Array(self.favourites.getFavouriteCitiesIDs()), id: \.self) { city in
                        FavouriteRowView(city: city)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct FavouriteRowView: View {
    var city: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image("map") 
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
            
            Text(city)
            Image(systemName: "heart.fill")
            
            //Button for checking weather in favourite location
            Button {
                
            } label: {
                Text("Check Weather")
            }
            .buttonStyle(CapsuleButtonStyle())
        }
        .padding(5)
        .padding(.vertical, 5)
        .background {
            Color.mint.opacity(0.2)
                .cornerRadius(10, corners: [.topLeft, .bottomRight, .bottomLeft])
        }
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(10, corners: [.topLeft, .topRight, .bottomLeft])
        }
    }
}

struct FavouritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesListView()
            .environmentObject(FavouritesViewModel())
    }
}

