//
//  LeaderboardView.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject var leaderboardTab = LeaderBoardTabRouter()
    
    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.buttonBlue)
                .frame(width: 500, height: 300)
                .offset(x: 0, y: -340)
           
            VStack {
                Text("Leaderboard")
                    .font(.custom("Montserrat-SemiBold", size: 28))
                    .padding(.vertical, 22)
                dateSelectionView(currentDateTab: $leaderboardTab.currentDateTab)
                
                SelfRankView()
                    .padding(.top, 20)
                Spacer()
                if leaderboardTab.currentDateTab == .allTime{
                    LeaderRankView()
                    Spacer()
                     ScrollView {
                    VStack(spacing: 30) {
                        LeaderboardRow()
                        LeaderboardRow()
                        LeaderboardRow()
                        LeaderboardRow()
                        LeaderboardRow()
                    } .padding(.bottom, 22)
                }
                }
                else if leaderboardTab.currentDateTab == .week{
                    
                }
                else if leaderboardTab.currentDateTab == .today{
                    
                }
                
            }
            .font(.custom("Montserrat-SemiBold", size: 16))
            .foregroundColor(.white)
            
        }
        
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

struct SelfRankView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 45){
            VStack {
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.8))
                    .font(.system(size: 13))
                Text("36")
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
        .shadow(radius: 15)
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
            Text("Joseph Merin")
                .padding(.leading, 10)
                .padding(.trailing, 80)
                .foregroundColor(.black)
            
            Text("286")
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(Color.black.opacity(0.25))
            Image(systemName: "stopwatch.fill")
                .foregroundColor(Color.black.opacity(0.25))
                .offset(x: 0, y: -2)
        }
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
    var body: some View {
        VStack{
            ProfilePicture(pictureSize: 70)
            Text("Steven Keiser")
                .foregroundColor(.black)
                .font(.custom("Montserrat-SemiBold", size: 12))
            HStack {
                Text("830")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(Color.black.opacity(0.25))
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.25))
                    .offset(x: 0, y: -2)
            }
            
        }
    }
}
