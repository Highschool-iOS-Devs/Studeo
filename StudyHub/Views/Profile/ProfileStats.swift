//
//  ProfileStats.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//


import SwiftUI

struct ProfileStats: View {
    @State var dayNum: Double = 0.0
    @State var monthNum: Double = 0.0
    @State var allNum: Double = 0.0
    @State var day: Bool = false
    @State var month: Bool = false
    @State var all: Bool = false
    var body: some View {
        
        if day {
            VStack {
                HStack {
                    Text("\(Int(dayNum))")
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(Color("Text").opacity(0.5))
                    Image(systemName: "stopwatch.fill")
                        .foregroundColor(Color("Text").opacity(0.5))
                        .offset(x: 0, y: -2)
                }
                Text("Day")
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(Color("Text").opacity(0.5))
            } .padding(.horizontal, 22)
        } else if month {
            VStack {
                HStack {
                    Text("\(Int(monthNum))")
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(Color("Text").opacity(0.5))
                    Image(systemName: "stopwatch.fill")
                        .foregroundColor(Color("Text").opacity(0.5))
                        .offset(x: 0, y: -2)
                }
                Text("Month")
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(Color("Text").opacity(0.5))
            } .padding(.horizontal, 22)
        } else if all {
            VStack {
                HStack {
                    
                    Text("\(Int(allNum))")
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(Color("Text").opacity(0.5))
                    Image(systemName: "stopwatch.fill")
                        .foregroundColor(Color("Text").opacity(0.5))
                        .offset(x: 0, y: -2)
                }
                Text("Month")
                    .font(.custom("Montserrat-SemiBold", size: 10))
                    .foregroundColor(Color("Text").opacity(0.5))
            } .padding(.horizontal, 22)
        }
    }
    
}

struct ProfileStats_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStats()
    }
}
