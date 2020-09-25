//
//  Leaderboard.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

struct SelfRankView: View {
    
        var hours:Double
    var body: some View {
        HStack(alignment: .center, spacing: 45){
            VStack {
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.8))
                    .font(.system(size: 13))
               Text("\(Int(hours))")
                    .foregroundColor(.black)
                HStack {
                    Text("Hours")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                }
                
            }
            ProfilePicture(pictureSize: 45)
            
            VStack {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                Text("96")
                    .foregroundColor(.black)
                Text("Ranking")
                    .foregroundColor(.black)
                    .padding(.top, 5)
            }
        }
        .font(.custom("Montserrat-SemiBold", size: 15))
        .frame(width: 300, height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(radius: 5)
        .opacity(0.7)
    }
}

struct ProfilePicture: View {
    var pictureSize:Int
    
    var body: some View {
        Image("demoprofile")
            .resizable()
            .clipShape(Circle())
            .aspectRatio(contentMode: .fill)
            .frame(width: CGFloat(pictureSize), height: CGFloat(pictureSize))
    }
}

struct LeaderboardRow: View {
    var name:String
     var hours:Double
    var body: some View {
        HStack{
          
            VStack {
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.green)
                Text("4")
                    .foregroundColor(.black)
            }
            ProfilePicture(pictureSize: 45)
             
            Text(name)
             
                .foregroundColor(.black)
                
            Spacer()
            Text("\(Int(hours))")
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(Color.black.opacity(0.25))
            Image(systemName: "stopwatch.fill")
                .foregroundColor(Color.black.opacity(0.25))
                .offset(x: 0, y: -2)
            
               
        } .padding(.horizontal, 42)
    }
}

struct dateSelectionView: View {
    @Binding var currentDateTab:LeaderBoardTabRouter.tabViews
    
    var body: some View {
        HStack(spacing: 25){
            VStack {
                Text("Today")
                    .foregroundColor(Color.white.opacity(0.25))
                    .onTapGesture {
                        self.currentDateTab = .today
                }
                Rectangle()
                    .fill(currentDateTab == .today ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
                    
            }
            .frame(width: 80)
            VStack {
                Text("Week")
                    .foregroundColor(Color.white.opacity(0.25))
                    .onTapGesture {
                        self.currentDateTab = .week
                }
                Rectangle()
                    .fill(currentDateTab == .week ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
            }
            .frame(width: 80)
            VStack {
                Text("All Time")
                .onTapGesture {
                        self.currentDateTab = .allTime
                }
                Rectangle()
                    .fill(currentDateTab == .allTime ? Color("primaryYellow") :  Color.white.opacity(0) )
                    .frame(width: 50, height: 7)
            }
            .frame(width: 80)
        }
        .animation(.easeInOut)
    }
}

struct LeaderRankView: View {
     var name:String
    var hours:Double
    var body: some View {
        VStack{
            ProfilePicture(pictureSize: 70)
            Text(name)
                .foregroundColor(.black)
                .font(.custom("Montserrat-SemiBold", size: 12))
            HStack {
               Text("\(Int(hours))")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(Color.black.opacity(0.25))
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.25))
                    .offset(x: 0, y: -2)
                
            }
            
        }
    }
}
