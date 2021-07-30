//
//  VectorImageRepresentable.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct VectorImageRepresentable:UIViewRepresentable{
    var image:UIImage
    var imageColor:Color?
    
    typealias UIViewType = UIImageView
    
    func makeUIView(context: Context) -> UIImageView {
        if let imageColor = imageColor{
            let tintableImage = image.withRenderingMode(.alwaysTemplate)
            let view = UIImageView(image: tintableImage)
            view.tintColor = UIColor(imageColor)
            view.contentMode = .scaleAspectFit
            return view
        }
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }
    func updateUIView(_ uiView: UIImageView, context: Context) {
        
    }
    
}

