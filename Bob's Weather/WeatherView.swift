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
        .onAppear {
            weatherViewModel.getForecast()
        }
        
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
}

struct WeatherSuccess : View {
    @EnvironmentObject var weatherViewModel: WeatherViewModelImplementation
    var forecast: Forecast
    
    init(forecast : Forecast) {
        self.forecast = forecast
    }
    
    var body: some View {
        ZStack {
            VStack {
                if let currentWeather = forecast.list.first(where: {
                    Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
                })
                {
                    switch currentWeather.weather.first!.main {
                        case let name where name == "Clear" :
                            Image("sea_sunny") //make this dynamic
                                .resizable()
                                .aspectRatio(3 / 2, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        case let name where name == "Rain" :
                            Image("sea_rainy") //make this dynamic
                                .resizable()
                                .aspectRatio(3 / 2, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        default:
                            Image("sea_cloudy") //make this dynamic
                                .resizable()
                                .aspectRatio(3 / 2, contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                            
                            
                    }
                    HStack {
                        iconView(currentWeather.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n min", currentWeather.main.tempMin))
                        
                        Spacer()
                        
                        iconView(currentWeather.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n current", currentWeather.main.temp))
                        
                        Spacer()
                        
                        iconView(currentWeather.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n max", currentWeather.main.tempMax))
                    }
                    .padding()
                    
                    LabelledDivider(label: "", horizontalPadding: -10, color: .white)
                    
                    RowView(weatherViewModel: weatherViewModel)
                } else {
                    VStack {
                        ErrorView(error: APIError.unknown){weatherViewModel.getForecast()}
                        PlaceholderImageView()
                    }
                }
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

