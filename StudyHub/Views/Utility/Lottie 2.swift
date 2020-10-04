//
//  Lottie.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView:UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let newView = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named("planeLoading")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        newView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: newView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: newView.widthAnchor)
        ])
        return newView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        
    }
    
    
    typealias UIViewType = UIView
    
    
}
