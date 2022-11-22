//
//  ContentView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/3/22.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModelImplementation
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        Group {
            switch locationViewModel.authorizationStatus {
                case .notDetermined :
                    AnyView(RequestLocationView())
                        .environmentObject(locationViewModel)
                case .restricted :
                    ErrorView(error: LocationError.locationRestricted) {
                        locationViewModel.requestPermission()
                    }
                case .denied :
                    ErrorView(error: LocationError.locationDenied) {}
                case .authorizedAlways, .authorizedWhenInUse :
                    Group {
                        switch weatherViewModel.state {
                            case .forecastSuccess(content: let forecast):
                                WeatherSuccess(forecast: forecast)
                                    .environmentObject(weatherViewModel)
                            case .loading :
                                VStack {
                                    ProgressView()
                                    Text("Loading weather data \(coordinate?.latitude ?? 0)")
                                }
                            case.failed(error: let error) :
                                ErrorView(error: error) {
                                    weatherViewModel.getForecast()
                                }
                        }
                    }
                default :
                    ErrorView(error: APIError.unknown){}
            }
        }
        //putting this on weather success //can't do that because it never appears because this function is never called
        .onAppear {
            weatherViewModel.getForecast() //should possibly use DispatchQueue here
            LocationViewModel.customLocation = nil
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
}

struct WeatherSuccess : View {
    @EnvironmentObject var weatherViewModel: WeatherViewModelImplementation
    @EnvironmentObject var favouritesViewModel: FavouritesViewModel
    @State private var showingSheet: Bool = false
    var forecast: Forecast
    
    init(forecast : Forecast) {
        self.forecast = forecast
    }
    
    var body: some View {
        if let weatherList = forecastResultStrip(forecast: forecast) {
            ZStack {
                VStack {
                    switch weatherList.first?.weather.first?.main {
                        case let name where name == "Clear" :
                            Image("sea_sunny")
                                .resizable()
                            //.aspectRatio(contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        case let name where name == "Rain" :
                            Image("sea_rainy")
                                .resizable()
                            //.aspectRatio(3 / 2, contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        default:
                            Image("sea_cloudy")
                                .resizable()
                            //.aspectRatio(3 / 2, contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: getRect().width, maxHeight: getRect().height)
                .overlay(alignment: .topTrailing) {
                    Button {
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
                            showErrorAlertView("Error", "Could not add curremt location to remote server", handler: {})
                        }

                    } label: {
                        Text("Add to Favourites")
                            .foregroundColor(.white)
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                            }
                    }

                }
                
                VStack {
                    Spacer ()
                    
                    VStack {
                        let minMax = forecastMinMax(forecast: forecast)
                        HStack {
                            //unexpected behaviour for min and max temperatures for the day. will look into purchasing license for 16 day forecast API
                            //minMax and weatherList.first.main produce the same values
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n min", minMax?.min ?? weatherList.first!.main.tempMin))
                            
                            Spacer()
                            
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n current", weatherList.first!.main.temp))
                            
                            Spacer()
                            
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n max", minMax?.max ?? weatherList.first!.main.tempMax))
                        }
                        .padding(.horizontal)
                        
                        LabelledDivider(label: "", horizontalPadding: -10, color: .white)
                            .glow(color: .white, radius: 1)
                            .frame(maxWidth : getRect().width)
                        
                        ForEach(weatherList) { list in
                            HStack(spacing: 0) {
                                CustomRow {
                                    Text(dayName(list.dt))
                                        .font(.caption)
                                        .padding(.leading)
                                        .frame(maxWidth: 150, alignment: .leading)
                                } center: {
                                    iconView(list.weather[0].main)
                                        .padding(.horizontal)
                                } right: {
                                    Text(String.localizedStringWithFormat("%.0f°", list.main.tempMax))
                                        .padding(.trailing)
                                }
                            }
                            .frame(maxWidth: getRect().width)
                        }
                    }
                    .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.55, alignment: .top)
                    //background here
                    .background {
                        switch weatherList.first?.weather.first?.main {
                            case let name where name == "Clear" :
                                Color.blue
                            case let name where name == "Rain" :
                                Color("rainy")
                            default:
                                Color("cloudy")
                        }
                    }
                }
                .frame(maxWidth: getRect().width, maxHeight: getRect().height)
            }
            .frame(maxWidth: getRect().width, maxHeight: getRect().height)
            .background {
                switch weatherList.first?.weather.first?.main {
                    case let name where name == "Clear" :
                        Color.blue
                    case let name where name == "Rain" :
                        Color("rainy")
                    default:
                        Color("cloudy")
                }
            }
        } else {
            VStack {
                ErrorView(error: APIError.unknown){weatherViewModel.getForecast()}
                PlaceholderImageView()
            }
        }
        
    }
}

func weatherImage(_ stringValueFromMain: String) -> Image {
    var imageName: String = ""
    
    switch stringValueFromMain {
        case let name where name == "Clear" :
            imageName = "clear"
        case let name where name == "Rain":
            imageName = "rain"
        default :
            imageName = "partlysunny"
    }
    
    return Image(imageName)
        .resizable()
        .scaledToFit() as! Image
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    @State private var progress: CGFloat = 0
    
    @State private var showingAnimation: Bool = true
    
    let backgroundGradient: Gradient = Gradient(colors: [.black.opacity(0.1), .gray.opacity(0.1)])
    let backgroundGradient2: Gradient = Gradient(colors: [.mint.opacity(0.1), .orange.opacity(0.1)])
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .background(.ultraThinMaterial)
                .foregroundColor(Color.primary.opacity(0.35))
                .foregroundStyle(.ultraThinMaterial)
                .modifier(FlatGlassView())
                .if(showingAnimation, transform: { view in
                    view
                        .animatableGradient(fromGradient: backgroundGradient2, toGradient: backgroundGradient, progress: progress)
                })
                    .ignoresSafeArea()
                    .onAppear {
                    withAnimation(.linear(duration: 5.0).repeatCount(2,autoreverses: true)) {
                        self.progress = 1.0
                    }
                }
                .onTapGesture {
                    showingAnimation = false
                    progress = 0
                }
            
            VStack(spacing: 20) {
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .padding()
                Button(action: {
                    locationViewModel.requestPermission()
                }, label: {
                    Label("Allow tracking", systemImage: "location")
                })
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                Text("We need your permission to access weather in your location.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding()
            }
            .modifier(FlatGlassView())
            .onTapGesture {
                showingAnimation = false
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .preferredColorScheme(.dark)
            .environmentObject(LocationViewModel())
            .environmentObject(WeatherViewModelImplementation(service: WeatherServiceImplementation()))
    }
}

