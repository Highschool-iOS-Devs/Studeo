//
//  Homev2.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Homev2: View {
    var columns = [
        GridItem(.fixed(250)),
        GridItem(.flexible()),
       
    ]
    var columns2 = [
        GridItem(.fixed(200)),
        GridItem(.flexible()),
       
    ]
    @State var columns3 = [GridItem]()
    @State var columns4 = [GridItem]()
    @State  var transition: Bool = false
    let screenSize = UIScreen.main.bounds
    @State private var showingTimer = false
    @State var size = CGSize(width: 0, height: -200)
    @State var size2 = CGSize(width: 0, height: 20000)
    @State var scrollOffset = 0
    @State var currentOffset = 0
    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack {
               
            Header(showTimer: $showingTimer)
         
                .onAppear() {
                    transition.toggle()
                }
                    ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)){
                VStack {
                    HStack {
                        ProfilePic()
                            .scaleEffect(1.2)
                            .offset(y: 75)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.1)
                                  
                            )
                            .transition(.move(edge: .top))
                        
                        ProfilePic()
                            .scaleEffect(1.1)
                            
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.2)
                                   
                                  
                            )
                            .transition(.move(edge: .top))
                    }
                   
                    HStack {
                        ProfilePic().scaleEffect(0.9)
                            .offset(y: 75)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.3)
                                  
                            )
                            .transition(.move(edge: .top))
                        
                        ProfilePic()
                            .scaleEffect(1.1)
                            .offset(y: -10)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.4)
                                   
                                  
                            )
                            .transition(.move(edge: .top))
                      
                    }
                }
                    
                    
                .offset(transition ? size : size2)
                
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.all)
                    
                    }
    }
            }
        }
    }


