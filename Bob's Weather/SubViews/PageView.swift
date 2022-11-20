//
//  PageView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/9/22.
//

import SwiftUI

// custom view to present UIViewControllerRepresentable view.

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: ImageViewModel().names.map({ FavouritesView(imageName: $0)
        })) //model will be needed here, to be passed into FavouritesView to create a true array of views
    }
}
