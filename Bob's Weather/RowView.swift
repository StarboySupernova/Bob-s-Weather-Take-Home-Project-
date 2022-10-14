//
//  RowView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/14/22.
//

import SwiftUI

struct RowView: View {
    
    @ObservedObject var weatherViewModel: WeatherViewModelImplementation
    
    var body: some View {
        Group {
            switch weatherViewModel.state{
                case .loading:
                    ProgressView()
                case .failed(let error):
                    ErrorView(error: error) {
                        weatherViewModel.getForecast() //another decision here
                    }
                case .forecastSuccess(let forecast):
                    Row(forecast: forecast)
            }
        }
        .onAppear {
            weatherViewModel.getForecast()
        }
    }
}

struct Row: View {
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showingSheet: Bool = false
    @State private var showingError: Bool = false
    let forecast: Forecast
    
    var body: some View {
        VStack {
            ForEach(forecast.list) { item in
                HStack(spacing: 0) {
                    Text(dayName(item.dt))
                        .padding(.leading)
                    
                    Spacer().frame(maxWidth: 500)
                    
                    iconView(item.weather[0].main)
                        .padding(.horizontal)
                    
                    Spacer().frame(minWidth: 0)
                    
                    Text(String.localizedStringWithFormat("%.0f°", item.main.tempMax))
                        .padding(.trailing)
                }
            }
        }
        .onTapGesture(count: 2) {
            if /*LocationViewModel.shared.lastSeenLocation != nil*/ let city = LocationViewModel.shared.currentPlacemark?.locality {
                //locationViewModel.addFavourite()
                if favouritesViewModel.contains(city) {
                    showingSheet.toggle()
                } else {
                let location = Locator(name: city, latitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.latitude)!, longitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.longitude)!)
                               favouritesViewModel.add(location)
                showingSheet.toggle()
                }
            } else {
                showingError.toggle()
            }
            /*if let city = LocationViewModel.shared.currentPlacemark?.locality {
                let location = Locator(name: city, latitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.latitude)!, longitude: (LocationViewModel.shared.lastSeenLocation?.coordinate.longitude)!)
                favouritesViewModel.add(location)
                showingSheet.toggle()
            } else {
                showingError.toggle()
            }*/
        }
        .sheet(isPresented: $showingSheet) {
            showingSheet = false
        } content: {
            FavouritesSuccessView()
        }
        .sheet(isPresented: $showingError) {
            showingError = false
        } content: {
            ErrorView(error: LocationError.locationRestricted) {}
        }
    }
}

struct FavouritesSuccessView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    
    var body: some View {
        Group {
            VStack {
                if let city = LocationViewModel.shared.currentPlacemark?.locality {
                    if favouritesViewModel.contains(city) {
                        Text("Current location already added to your favourites")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    } else {
                        Text("Added current location \(city) to your favourites")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }

                Button {
                    dismiss()
                } label: {
                    Text("OK")
                }
            }
            .background(.ultraThinMaterial)
        }
    }
}

@ViewBuilder func iconView(_ weatherMainStringValue: String, label: String = "") -> some View {
    switch weatherMainStringValue {
        case let maindesc where maindesc == "Clear" :
            Label{
                Text(label)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.green)
            } icon: {
                Image("clear")
                    .resizable()
                    .scaledToFit()
            }
            .labelStyle(CaptionLabelStyle())
            
        case let maindesc where maindesc == "Rain":
            Label{
                Text(label)
                    .multilineTextAlignment(.center)
            } icon: {
                Image("rain")
                    .resizable()
                    .scaledToFit()
            }
            .labelStyle(CaptionLabelStyle())

        default:
            Label{
                Text(label)
                    .multilineTextAlignment(.center)
            } icon: {
                Image("partlysunny")
                    .resizable()
                    .scaledToFit()
            }
            .labelStyle(CaptionLabelStyle())
    }
}


struct PlaceholderImageView: View {
    var body: some View {
        Image(systemName: "photo.fill")
            .foregroundColor(.white)
            .background(Color.gray)
            .frame(width: 100, height: 100)
    }
}

func dayName(_ unixValue: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(unixValue))
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(weatherViewModel: WeatherViewModelImplementation(service: WeatherServiceImplementation()))
            .preferredColorScheme(.dark)
    }
}
