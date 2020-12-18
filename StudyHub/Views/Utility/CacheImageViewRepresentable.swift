//
//  CacheImageViewRepresentable.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Kingfisher

struct CacheImageViewRepresentable:UIViewRepresentable{
    var url:URL
    
    typealias UIViewType = UIImageView
    
    func makeUIView(context: Context) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.kf.indicatorType = .activity
        view.kf.setImage(with: url, options: [.transition(.fade(0.2))])
        return view
    }
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }

}
