//
//  WalkthroughView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/7/22.
//

import SwiftUI

struct WalkThroughView: View {
    @State var offset: CGFloat = 0
    @Binding var showHome: Bool
    @Binding var showWalkthrough: Bool
    var screenSize: CGSize
    
    var body: some View {
        VStack {
            HStack {
                Text("Weather App")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                
                Spacer()
                
                Button {
                    //skip the walkthrough
                    showHome = true
                } label: {
                    Text("Skip")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 20)
                .padding()
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            
            OffsetPageTabView(offset: $offset) {
                HStack(spacing: 0){
                    ForEach(intros) {intro in
                        VStack {
                            Image(systemName: intro.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: screenSize.height / 3)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text(intro.title)
                                    .font(.largeTitle)
                                    .bold()
                                
                                Text(intro.description)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                            .foregroundStyle(.white)
                            .padding(.top, 50)
                        }
                        .padding()
                        .frame(width: screenSize.width)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            HStack(alignment: .bottom) {
                
                HStack(spacing: 12) {
                    ForEach(intros.indices, id: \.self) { index in
                    Capsule()
                            .fill(.white)
                            .frame(width: getOffsetIndex() == index ? 20 : 7, height: 7)
                    }
                }
                .overlay(
                    Capsule()
                        .fill(.white)
                        .frame(width: 20, height: 7)
                        .offset(x: getIndicatorOffset())
                    , alignment: .leading)
                
                Spacer()
                
                Button {
                    let index = min(getOffsetIndex() + 1, intros.count - 1)
                    offset = CGFloat(index) * screenSize.width
                    //should enable functionality for it to pivot to MainView() when the end of intros is reached, same functionality for skip button
                    if getOffsetIndex() == (intros.count - 1) {
                        showHome = true
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(20)
                        .background(intros[getOffsetIndex()].color, in: Circle())
                }

            }
            .padding(.horizontal)
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .top)
        .animation(.easeInOut, value: getOffsetIndex())
    }
    
    func getIndicatorOffset() -> CGFloat {
        let progress = offset / screenSize.width
        //12 from HStack spacing, 7 from Circle size
        let maxWidth: CGFloat = 12 + 7
        return progress * maxWidth
    }
    
    func getOffsetIndex() -> Int {
        let progress = round(offset / screenSize.width)
        let index = min(Int(progress), intros.count - 1)
        return index
    }
}

struct WalkthroughView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showHome: .constant(false), showWalkthrough: .constant(true))
            .preferredColorScheme(.dark)
    }
}
