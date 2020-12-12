//
//  ARChatView.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/11/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import Foundation
import SwiftUI

struct ARVideoChatView: UIViewControllerRepresentable {
  
    @Binding var channelName: String
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARVideoChatView>) -> UIViewController {
        let picker = ARChat()
        
                      
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ARVideoChatView>) {
       
    }
}
