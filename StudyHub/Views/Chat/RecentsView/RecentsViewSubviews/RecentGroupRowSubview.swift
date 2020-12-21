//
//  RecentChatRowSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/27/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentGroupRowSubview: View {
   @State var group: Groups
    @State var tapped:Bool = false
    var profilePicture:Image
    @EnvironmentObject var userData: UserData
    @State var chat = false
    @State var sentTime = ""
    @State var messagePreview = ""
    var body: some View {
        //Chat row background
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
   
            HStack {
                ProfileRingView(size: 53)
                VStack {
                    Text(group.groupName).font(.custom("Montserrat SemiBold", size: 15)).foregroundColor(Color(#colorLiteral(red: 0, green: 0.6, blue: 1, alpha: 1)))
                            .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        Text(messagePreview).font(.custom("Montserrat Regular", size: 12))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.57, blue: 0.82, alpha: 1)))
                }
                .padding(.vertical, 20)
                .padding(.trailing, 15)
                
                VStack {
                    ZStack {
                        Circle()
                        .fill(Color(#colorLiteral(red: 0.9666666388511658, green: 0.257515013217926, blue: 0.2497221827507019, alpha: 1)))
                        .frame(width: 16, height: 16)
               
                        Text("8").font(.custom("Montserrat SemiBold", size: 9)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                        .textCase(.uppercase)
                    }
                    Text(sentTime).font(.custom("Montserrat Regular", size: 12)).foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.57, blue: 0.82, alpha: 1))).multilineTextAlignment(.center)


                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 91)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865, green: 0.7666666508, blue: 1, alpha: 0.3000000119)), radius:7, x:0, y:7)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865348816, green: 0.7666666507720947, blue: 1, alpha: 0.30000001192092896)), radius:7, x:3, y:0)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865348816, green: 0.7666666507720947, blue: 1, alpha: 0.30000001192092896)), radius:7, x:-3, y:0)
        .onTapGesture{
            tapped = true
        }
        .sheet(isPresented: self.$tapped){
            ChatView(group: group, chat: $chat)
                .environmentObject(userData)
        }
        .onAppear{
            getTimeAndMessageRecord()
        }
    }
    func getTimeAndMessageRecord(){
        let db = Firestore.firestore()
        let ref = db.collection("message/\(group.groupID)/messages/").order(by: "sentTime", descending: true).limit(to: 1)
        ref.addSnapshotListener{querySnapshot, error in
            if let error = error{
                print("Error adding time record, \(error)")
            }
            else{
                for document in querySnapshot!.documents{
                    let result = Result {
                         try document.data(as: MessageData.self)
                       }
                       switch result {
                       case .success(let message):
                           if let message = message {
                                let time = message.sentTime
                                sentTime = formatMessageTime(for: time)
                                messagePreview = message.messageText
                                
                           } else {
               
                               print("Document does not exist")
                           }
                       case .failure(let error):
                           // A `City` value could not be initialized from the DocumentSnapshot.
                           print("Error decoding city: \(error)")
                       }
                }
            }
        }
    }
    
    func formatMessageTime(for timeSent:Date) -> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let formattedDate = formatter.string(from: timeSent)
        return formattedDate

   
    }
}

struct RecentChatRowSubview_Previews: PreviewProvider {
    static var previews: some View {
        RecentGroupRowSubview(group: Groups(id: "", groupID: "", groupName: "SAT Group", members: [""], interests: [nil]), profilePicture: Image("demoprofile"))
    }
}
