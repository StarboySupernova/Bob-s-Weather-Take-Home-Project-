//
//  MenuView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/6/22.
//

import SwiftUI
import SwiftUIVisualEffects

struct MenuView: View {
    //selected tab
    @State private var selectedTab: String = "Weather"
    @State private var showMenu: Bool = true
    
    var body: some View {
        ResponsiveView { prop in
            ZStack(alignment: .leading) {
                if showMenu || (prop.isiPad && !prop.isSplit) {
                    ScrollView(getRect().height < 750 ? .vertical : .init(), showsIndicators: false) {
                        SideMenu(selectedTab: $selectedTab)
                    }
                    .frame(maxWidth: getRect().width * 0.7)
                }
                
                ZStack {
                    //2 background cards
                    Color.white
                        .opacity(0.5)
                        .cornerRadius(showMenu ? 15 : 0)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: 0)
                        .offset(x: showMenu ? -25 : 0)
                        .padding(.vertical, 30)
                    
                    Color.white
                        .opacity(0.4)
                        .cornerRadius(showMenu ? 15 : 0)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: 0)
                        .offset(x: showMenu ? -50 : 0)
                        .padding(.vertical, 60)
                    
                    LandingView(selectedTab: $selectedTab)
                        .cornerRadius(showMenu ? 20 : 0)
                        .glow(color: showMenu ? .cyan.opacity(0.3): .clear, radius:showMenu ? 10: 0)
                    
                }
                //Scaling and moving the view
                .scaleEffect(showMenu ? 0.84 : 1)
                .offset(x: showMenu ? getRect().width - 120 : 0)
                .ignoresSafeArea()
                .overlay (
                    //menu button
                    Button {
                        withAnimation(.spring()) {
                            showMenu.toggle()
                        }
                    } label: {
                        //Animated drawer button
                        VStack(spacing: 5) {
                            Capsule()
                                .fill(showMenu ? Color.white : Color.gray)
                                .frame(width: 30, height: 3)
                                .rotationEffect(.init(degrees: showMenu ? -49.9 : 0.01))
                                .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)
                            VStack(spacing: 5) {
                                Capsule()
                                    .fill(showMenu ? Color.white : Color.gray)
                                    .frame(width: 30, height: 3)
                                //moving up when clicked
                                Capsule()
                                    .fill(showMenu ? Color.white : Color.gray)
                                    .frame(width: 30, height: 3)
                                    .offset(y: showMenu ? -8 : 0)
                            }
                            .rotationEffect(.init(degrees: showMenu ? 49.9 : 0.9))
                        }
                        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 0)
                        //.glow(color: .black.opacity(0.5), radius: 2)
                    }
                        .if(!showMenu, transform: { view in
                            view
                                .buttonStyle(ColorfulButtonStyle())
                        })
                        .padding(.vertical) //useful to learn to detect which phones have a notch here
                    
                    ,alignment: .topLeading
                )
            }
            
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.dark)
    }
}

