//
//  ErrorView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/15/22.
//

import SwiftUI

struct ErrorView: View {
    typealias ErrorViewActionHandler = () -> Void
    
    let error: Error
    let handler: ErrorViewActionHandler
    
    internal init(error: Error, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }

    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .black, design: .rounded))
                .padding(.bottom, 5)
            
            Text("Sorry, something went wrong here")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            
            Text(error.localizedDescription)
                .foregroundColor(.gray)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.vertical, 5)
            
            Button {
                handler()
            } label: {
                Text("Retry")
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .heavy, design: .rounded))
            .cornerRadius(10)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.decodingError) {}
    }
}
