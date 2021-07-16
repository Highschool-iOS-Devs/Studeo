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
    @State var id = ""
    var body: some View {
        
        HStack(alignment: .center) {
            ProfilePic(name: "", id: id)
                .frame(width: 75, height: 75)
            Spacer()
            VStack {
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color("Text").opacity(0.8))
                    .font(.system(size: 13))
               Text(hours.removeZerosFromEnd())
                    .foregroundColor(Color("Text"))
                HStack {
                    Text("All Time Hours")
                        .foregroundColor(Color("Text"))
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
        .font(Font.custom("Montserrat-SemiBold", size: 14, relativeTo: .subheadline))
        .frame(width: 300, height: 100)
        .background(Color("Card"))
       // .opacity(0.6)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color("CardShadow") ,radius: 6)
    }
}

struct ProfilePicture: View {
    var pictureSize:Int
    @State var image:Image
    @State var id = ""
    var body: some View {
        ProfilePic(name: "", id: id)
            .frame(width: 75, height: 75)
            
    }
}

struct LeaderboardRow: View {
    var name:String
    var hours:[Double]
     var id = ""
    @State var showGreenArrow:Bool = false
    init(name:String, hours:[Double], id: String){
        self.name = name
        self.hours = hours
        self.showGreenArrow = parseHours()
        self.id = id
    }
    
    var body: some View {
        HStack{
            VStack {
                //Image(systemName: showGreenArrow ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                //    .font(.system(size: 13))
                //    .foregroundColor(showGreenArrow ? Color(.green) : Color(.red))
              //  Text("4")
                //    .foregroundColor(Color("Text"))
            }
            ProfilePic(name: "", id: id)
                .frame(width: 75, height: 75)
            
            Text(name)
                .foregroundColor(Color("Text"))

            Spacer()
            Text("\(hours.last!.removeZerosFromEnd()) hour")
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(Color("Text").opacity(0.25))
            Image(systemName: "stopwatch.fill")
                .foregroundColor(Color("Text").opacity(0.25))
                .offset(x: 0, y: -2)
            
               
        } .padding(.horizontal, 42)
    }
    
    func parseHours() -> Bool{
        let hourSlice = Array(hours.suffix(2))
        if hourSlice.count > 2{
            if hourSlice[1] > hourSlice[0]{
                return true
            }
            else{
                return false
            }
        }
        else{
            return false
        }
     
    }
}

struct dateSelectionView: View {
    @Binding var currentDateTab:LeaderBoardTabRouter.tabViews
    @State  var testing = false
    var body: some View {
        HStack(spacing: 25){
            if testing {
            VStack {
                
                Text("Today")
                    .foregroundColor(Color(.white).opacity(self.currentDateTab == .today ? 1 : 0.25))
                    .onTapGesture {
                        self.currentDateTab = .today
                }
                Rectangle()
                    .fill(currentDateTab == .today ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
                    
            }
          
            VStack {
                Text("Month")
                    .foregroundColor(Color(.white).opacity(self.currentDateTab == .month ? 1 : 0.25))
                    .onTapGesture {
                        self.currentDateTab = .month
                }
                Rectangle()
                    .fill(currentDateTab == .month ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
            }
            }
            VStack {
                Text("All Time")
                    .foregroundColor(Color(.white).opacity(self.currentDateTab == .allTime ? 1 : 0.25))
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
    var hours:[Double]
    @State var id = ""
    var body: some View {
        
        VStack{
            ProfilePic(name: "", id: id)
                .frame(width: 75, height: 75)
            Text(name)
                .foregroundColor(Color("Text"))
                .font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .headline))
            HStack {
                Text(hours.last!.removeZerosFromEnd())
                    .font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .headline))
                    .foregroundColor(Color("Text").opacity(0.25))
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color("Text").opacity(0.25))
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
                LeaderRankView(name: leaders[1].name, hours: leaders[1].studyHours, id: leaders[1].id.uuidString)
                    .offset(x: 0, y: 10)
            }
            if leaders.isEmpty {
            } else {
                LeaderRankView(name: leaders[0].name, hours: leaders[0].studyHours, id: leaders[0].id.uuidString)
            }
            
            if leaders.count > 2 {
                LeaderRankView(name: leaders[2].name, hours: leaders[2].studyHours, id: leaders[2].id.uuidString)
                    .offset(x: 0, y: 10)
            }
        }
    }
}

