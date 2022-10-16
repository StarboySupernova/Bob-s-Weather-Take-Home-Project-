//
//  FavouritesListView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/14/22.
//

import SwiftUI
import CoreLocation

struct FavouritesListView: View {
    @EnvironmentObject var favourites: FavouritesViewModel
    var body: some View {
        Group {
            VStack(spacing: 20) {
                PageView(pages: ImageViewModel().names.map{FavouritesView(imageName: $0)})
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                
                Group {
                    if favourites.isEmpty() {
                        VStack{
                            Text("You have no favourites yet")
                                .foregroundColor(.white)
                        }
                    } else {
                        List(Array(self.favourites.favouriteCities)) { city in
                            FavouriteRowView(city: city.name)
                                .frame(maxWidth: getRect().width)
                        }                        
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
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    @EnvironmentObject var weatherViewModel: WeatherViewModelImplementation
    
    @State private var showingCustom: Bool = false
    @State private var showingError: Bool = false
    @State private var customLocation: CLLocationCoordinate2D? = nil
    
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
                if let extractedCity = favouritesViewModel.first(occurring: city) {
                    LocationViewModel.locationProvider(latitude: extractedCity.latitude, longitude: extractedCity.longitude)
                    if LocationViewModel.customLocation != nil {
                        weatherViewModel.getForecast()
                        showingCustom.toggle()
                    }
                }
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
        .sheet(isPresented: $showingCustom) {
            LocationViewModel.customLocation = nil 
        } content: {
            switch weatherViewModel.state {
                case .forecastSuccess(content: let forecast) :
                    WeatherSuccess(forecast: forecast)
                case .loading :
                    ProgressView()
                case .failed(error: let error) :
                    ErrorView(error: error) {
                        weatherViewModel.getForecast()
                    }
            }
        }

    }
}

struct FavouritesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesListView()
            .environmentObject(FavouritesViewModel())
    }
}

