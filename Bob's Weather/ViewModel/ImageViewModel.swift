//
//  ImageViewModel.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 9/13/22.
//

import Foundation
import Combine


class ImageViewModel: ObservableObject {
    @Published var imageNames = StaticImage.allCases
    
    let imageEmitter = CurrentValueSubject<StaticImage, Never>(.tropical)
    
    var names: [String] {
        imageNames.map{$0.rawValue}
    }
}

extension ImageViewModel{
     func imageChange() {
        for img in StaticImage.allCases {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [unowned self] in
                self.imageEmitter.send(img)
            }
        }
    }
}
