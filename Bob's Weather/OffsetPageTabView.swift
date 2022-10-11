//
//  OffsetPageTabView.swift
//  Bob's Weather
//
//  Created by Simbarashe Dombodzvuku on 10/7/22.
//

import SwiftUI

struct OffsetPageTabView<Content: View>: UIViewRepresentable {

    var content: Content
    @Binding var offset: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping () -> Content) {
        self._offset = offset
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {

        let scrollView = UIScrollView()

        //Extracting SwiftUI View and embedding it into UIKit ScrollView
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            //if you are using vertical paging in future, do not declare height constraint
            hostView.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

        ]
        
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        
        //enabling paging
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.delegate = context.coordinator
        
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //only updating when offset in x-plane changes manually, i.e. when Walkthrough button is tapped
        let currentOffset = uiView.contentOffset.x
        if currentOffset != offset {
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    //Pager offset
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            parent.offset = offset
        }
        
    }
}


struct OffsetPageTabView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showHome: .constant(false), showWalkthrough: .constant(true))
    }
}
