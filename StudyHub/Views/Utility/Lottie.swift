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
    @State var name = "planeLoading"
    @State var loop = true
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let newView = UIView(frame: .zero)
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        if loop {
        animationView.loopMode = .loop
        } else {
            animationView.loopMode = .playOnce
        }
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
