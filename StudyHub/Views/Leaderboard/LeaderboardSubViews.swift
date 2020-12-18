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
        HStack(alignment: .center) {
            ProfileRingView(size: 60)
            
            Spacer()
            VStack {
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.8))
                    .font(.system(size: 13))
               Text(hours.removeZerosFromEnd())
                    .foregroundColor(.black)
                HStack {
                    Text("All Time Hours")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                }
                
            }
           
          
            
            VStack {
                //Image(systemName: "arrowtriangle.down.fill")
                    //.font(.system(size: 13))
                    //.foregroundColor(.red)
               // Text("96")
                  //  .foregroundColor(.black)
                //Text("Ranking")
                  //  .foregroundColor(.black)
                   // .padding(.top, 5)
            }
        } .padding()
        .font(.custom("Montserrat-SemiBold", size: 15))
        .frame(width: 300, height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(radius: 5)
    }
}

struct ProfilePicture: View {
    var pictureSize:Int
    @State var image:Image
    var body: some View {
        image
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
            ProfilePicture(pictureSize: 45, image: Image("demoprofile"))
             
            Text(name)
             
                .foregroundColor(.black)
                
            Spacer()
            Text(hours.removeZerosFromEnd())
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
                    .foregroundColor(Color.white.opacity(self.currentDateTab == .today ? 1 : 0.25))
                    .onTapGesture {
                        self.currentDateTab = .today
                }
                Rectangle()
                    .fill(currentDateTab == .today ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
                    
            }
            
            VStack {
                Text("Month")
                    .foregroundColor(Color.white.opacity(self.currentDateTab == .month ? 1 : 0.25))
                    .onTapGesture {
                        self.currentDateTab = .month
                }
                Rectangle()
                    .fill(currentDateTab == .month ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
            }
            
            VStack {
                Text("All Time")
                    .foregroundColor(Color.white.opacity(self.currentDateTab == .allTime ? 1 : 0.25))
                    .onTapGesture {
                        self.currentDateTab = .allTime
                    }
                Rectangle()
                    .fill(currentDateTab == .allTime ? Color("primaryYellow") :  Color.white.opacity(0) )
                    .frame(width: 50, height: 7)
            }
          
        } .padding()
        .animation(.easeInOut)
    }
}

struct LeaderRankView: View {
     var name:String
    var hours:Double
    var body: some View {
        VStack{
            ProfilePicture(pictureSize: 70, image: Image("demoprofile"))
            Text(name)
                .foregroundColor(.black)
                .font(.custom("Montserrat-SemiBold", size: 12))
            HStack {
               Text(hours.removeZerosFromEnd())
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(Color.black.opacity(0.25))
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.25))
                    .offset(x: 0, y: -2)
                
            }
            
        }
    }
}

struct LeadersStack: View {
    var leaders: [User]
    var body: some View {
        HStack(spacing: 30) {
            if leaders.count > 1 {
                LeaderRankView(name: leaders[1].name, hours: leaders[1].studyHours)
                    .offset(x: 0, y: 10)
            }

            LeaderRankView(name: leaders[0].name, hours: leaders[0].studyHours)
            
            if leaders.count > 2 {
                LeaderRankView(name: leaders[2].name, hours: leaders[2].studyHours)
                    .offset(x: 0, y: 10)
            }
        }
    }
}

