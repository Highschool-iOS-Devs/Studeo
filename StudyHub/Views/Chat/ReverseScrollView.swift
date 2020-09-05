//
//  ReverseScrollView.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/5/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ReverseScrollView<Content>: View where Content: View {
    @State private var contentHeight: CGFloat = CGFloat.zero
    @State  var scrollOffset: CGFloat = CGFloat.zero
    @State var currentOffset: CGFloat = CGFloat.zero
    @State var hasPressedUp = false
    @State var topLimit = CGFloat(0)
    @State var accessability = false
    var content: () -> Content
    
    // Calculate content offset
    func offset(outerheight: CGFloat, innerheight: CGFloat) -> CGFloat {
        print("outerheight: \(outerheight) innerheight: \(innerheight)")
        
        let totalOffset = currentOffset + scrollOffset
        return -((innerheight/2 - outerheight/2) - totalOffset)
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            // Render the content
            //  ... and set its sizing inside the parent
            self.content()
                .modifier(ViewHeightKey())
                .onPreferenceChange(ViewHeightKey.self) { self.contentHeight = $0 }
                .frame(height: outerGeometry.size.height)
                .offset(y: self.offset(outerheight: outerGeometry.size.height, innerheight: self.contentHeight))
                .clipped()
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .onChanged({ self.onDragChanged($0) })
                        .onEnded({ self.onDragEnded($0, outerHeight: outerGeometry.size.height)}))
            
            VStack {
                HStack {
                    Spacer()
                    if self.contentHeight > 530 {
                        if self.accessability {
                        Text("Scroll up")
                            .foregroundColor(.black)
                            .padding()
                            .background(BlurView(style: .systemUltraThinMaterial)).clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            .onTapGesture {
                                print("scroll up")
                                let scrollOffset = self.scrollOffset + 60
                                print("Ended currentOffset=\(self.currentOffset) scrollOffset=\(scrollOffset)")
                                
                                self.topLimit = CGFloat(Int(self.contentHeight - outerGeometry.size.height))
                                print("toplimit: \(self.topLimit)")
                                
                                // Negative topLimit => Content is smaller than screen size. We reset the scroll position on drag end:
                                if self.topLimit < 0 {
                                    self.currentOffset = 0
                                } else {
                                    // We cannot pass bottom limit (negative scroll)
                                    if self.currentOffset + scrollOffset < 0 {
                                        self.currentOffset = 0
                                    } else if self.currentOffset + scrollOffset > self.topLimit {
                                        self.currentOffset = CGFloat(self.topLimit)
                                    } else {
                                        self.currentOffset += scrollOffset
                                    }
                                }
                                print("new currentOffset=\(self.currentOffset)")
                                self.scrollOffset = 0
                        }
                    }
                    }
                    
                    Spacer()
                    
                    
                } .padding(.vertical, 22)
                
                Spacer(minLength: 300)
                HStack {
                    Spacer()
                    if self.currentOffset >= 30 {
                         if self.accessability {
                        Text("Scroll down")
                            .foregroundColor(.black)
                            .padding()
                            .background(BlurView(style: .systemUltraThinMaterial)).clipShape(RoundedRectangle(cornerRadius: 10))
                            .zIndex(1)
                            .onTapGesture {
                                print("scroll down")
                                let scrollOffset = self.scrollOffset - 80
                                print("Ended currentOffset=\(self.currentOffset) scrollOffset=\(scrollOffset)")
                                
                                let topLimit = self.contentHeight - outerGeometry.size.height
                                print("toplimit: \(topLimit)")
                                self.topLimit = self.contentHeight - outerGeometry.size.height
                                print("toplimit: \(topLimit)")
                                // Negative topLimit => Content is smaller than screen size. We reset the scroll position on drag end:
                                
                                if self.topLimit < 0 {
                                    self.currentOffset = 0
                                } else {
                                    // We cannot pass bottom limit (negative scroll)
                                    if self.currentOffset + scrollOffset < 0 {
                                        self.currentOffset = 0
                                    } else if self.currentOffset + scrollOffset > topLimit {
                                        self.currentOffset = topLimit
                                    } else {
                                        self.currentOffset += scrollOffset
                                    }
                                }
                                print("new currentOffset=\(self.currentOffset)")
                                self.scrollOffset = 0
                        }
                    }
                    }
                    Spacer()
                }
                Spacer()
            }.padding(.vertical, 22)
        }
    }
    
    func onDragChanged(_ value: DragGesture.Value) {
        // Update rendered offset
        print("Start: \(value.startLocation.y)")
        print("Start: \(value.location.y)")
        self.scrollOffset = (value.location.y - value.startLocation.y)
        print("Scrolloffset: \(self.scrollOffset)")
    }
    
    func onDragEnded(_ value: DragGesture.Value, outerHeight: CGFloat) {
        // Update view to target position based on drag position
        let scrollOffset = value.location.y - value.startLocation.y
        print("Ended currentOffset=\(self.currentOffset) scrollOffset=\(scrollOffset)")
        
        let topLimit = self.contentHeight - outerHeight
        print("toplimit: \(topLimit)")
        
        // Negative topLimit => Content is smaller than screen size. We reset the scroll position on drag end:
        if topLimit < 0 {
            self.currentOffset = 0
        } else {
            // We cannot pass bottom limit (negative scroll)
            if self.currentOffset + scrollOffset < 0 {
                self.currentOffset = 0
            } else if self.currentOffset + scrollOffset > topLimit {
                self.currentOffset = topLimit
            } else {
                self.currentOffset += scrollOffset
            }
        }
        print("new currentOffset=\(self.currentOffset)")
        self.scrollOffset = 0
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

extension ViewHeightKey: ViewModifier {
    func body(content: Content) -> some View {
        return content.background(GeometryReader { proxy in
            Color.clear.preference(key: Self.self, value: proxy.size.height)
        })
    }
}

