//
//  ErrorView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/31/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Temp: View {
    @State private var show = false
    var body: some View {
        ZStack {
            Color.red.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            Button(action: { self.show.toggle() }) {
                Text("Press to show Error")
            }
            
            if self.show {
                ErrorView(show: self.$show, errorTitle: "Error!", errorMsg: "There was an error")
            }
        }
    }
}

struct ErrorView: View {
    
    @Binding var show: Bool
    var errorTitle: String
    var errorMsg: String
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 17) {
                HStack {
                    Text(errorTitle)
                        .font(.custom("Montserrat-SemiBold", size: 30))
                        .foregroundColor(Color(UIColor.systemRed))
                    Spacer()
                }
                .padding()
                Text(errorMsg)
                    .font(.custom("Montserrat-Medium", size: 15))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                Button(action: { self.show.toggle() }){
                    Text("Ok")
                }
                .buttonStyle(BlueStyle())
                .clipShape(Capsule())
                .frame(width: 200)
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 30)
            .background(Color.white)
            .cornerRadius(25)
            
            Button(action: { self.show.toggle() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.8))
            }
            .padding()
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Temp()
    }
}
