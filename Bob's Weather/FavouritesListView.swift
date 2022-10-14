//
//  FavouritesListView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/14/22.
//

import SwiftUI

struct FavouritesListView: View {
    //@EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var favourites: FavouritesViewModel
    var body: some View {
        Group {
            VStack(spacing: 20) {
                PageView(pages: ImageViewModel().names.map{FavouritesView(imageName: $0)})
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                
                Group {
                    if /*locationViewModel.favourited.isEmpty*/ favourites.isEmpty() {
                        VStack{
                            Text("You have no favourites yet")
                                .foregroundColor(.white)
                        }
                    } else {
                        List(Array(self.favourites.favouriteCities)) { city in
                            FavouriteRowView(city: city.name)
                        }
                        /*List(locationViewModel.favourited) { city in
                            FavouriteRowView(city: city)
                        }*/
                        /*ForEach(locationViewModel.favourited.compactMap{$0.value}, id: \.self) { loc in
                            FavouriteRowView(city: loc.locality!)
                        }*/
                    }
                }
                .frame(maxWidth: getRect().width)
                
                Spacer()
                
                Button {
                    favourites.refresh()
                    print(favourites.favouriteCities.count)
                } label: {
                    Text("Refresh")
                        .foregroundColor(.white)
                }

            }
        }
        .padding(.top, safeArea().top)
        .onAppear {
            //favourites.refresh()
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
        .background(
            HStack {
                Spacer()
            }
                .padding(.horizontal)
                .padding(.top, safeArea().top)
                .padding(.bottom, 60)
                .background(Color("unicorn"))
                .opacity(0.5)
                .clipShape(
                    Corners(corner: [.bottomRight, .topLeft], size: CGSize(width: getRect().width, height: 20))
                )
        )
        .modifier(FlatGlassView())
    }
}

struct FavouritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesListView()
            .environmentObject(FavouritesViewModel())
    }
}

