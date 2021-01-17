//
//  DynamicHeightTextField.swift
//  StudyHub
//
//  Created by Jevon Mao on 1/16/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//
//
import SwiftUI

struct DynamicHeightTextField: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return DynamicHeightTextField.Coordinator(dynamicHeightTextField: self)
    }
    
    @Binding var text:String
    @Binding var height:CGFloat
    var width:CGFloat
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont(name: "Montserrat-Medium", size: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.isEditable = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = false
        textView.alwaysBounceVertical = true
        textView.text = "Enter message"
        textView.textColor = UIColor(named: "Text")?.withAlphaComponent(0.5)
        textView.backgroundColor = UIColor.clear
        textView.delegate = context.coordinator
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addConstraint(NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160))
        textView.addConstraint(NSLayoutConstraint(item: textView, attribute: .width, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        var dynamicHeightTextField :DynamicHeightTextField
        weak var textView: UITextView?
        let maximumHeight:CGFloat = 160

        init(dynamicHeightTextField: DynamicHeightTextField){
            self.dynamicHeightTextField = dynamicHeightTextField
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.textColor = UIColor(named: "Text")
            textView.text = ""
        }
        func textViewDidChange(_ textView: UITextView) {
            print(textView.contentSize.height)
            DispatchQueue.main.async {
                if textView.contentSize.height < 160{
                    self.dynamicHeightTextField.text = textView.text
                    self.dynamicHeightTextField.height = textView.contentSize.height
                    textView.isScrollEnabled = false

                }
                else{
                    self.dynamicHeightTextField.text = textView.text
                   textView.isScrollEnabled = true

                }


            }
        }
        
        
       
    }
    
}

 
