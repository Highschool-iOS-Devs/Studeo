//
//  VoiceChat.swift
//  StudyHub
//
//  Created by Andreas on 12/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import AgoraRtcKit
import Firebase
import FirebaseFirestoreSwift
struct VoiceChat: View {
    @EnvironmentObject var userData: UserData
    @State var agoraKit: AgoraRtcEngineKit
    @State var token = ""
    @State var name = ""
    @State var isMuted = false
    @Binding var vc: Bool
    @State var group: Groups?
    @State var usersInVC = [User]()
    @State var i = 0
    var body: some View {
        ZStack {
        Color("Background").edgesIgnoringSafeArea(.all)
            .onDisappear() {
               // agoraKit.leaveChannel(nil)
                UIApplication.shared.isIdleTimerDisabled = false
            }
            .onAppear() {
                
                let db = Firestore.firestore()
               
                let ref2 = db.collection("groups").document(group!.groupID)
                ref2.getDocument{document, error in
                    
                    if let document = document, document.exists {
                        
                 
                        let groupListCast = document.data()?["userInVC"] as? [String]
                        
                        if var currentGroups = groupListCast {
                            
                            currentGroups.append(userData.userID)
                            ref2.updateData(
                                [
                                    "userInVC": currentGroups.removeDuplicates()
                                ]
                            )
            }
                    }
                }
                self.loadUsersInVC() { userData in
                    
                    group = userData.first!
                    self.loadUsersData() { userData in
                        usersInVC.removeAll()
                        usersInVC = userData
                        
                    }
                }
                initializeAgoraEngine()
                joinChannel()
                
             
            }
        
           
            VStack {
                HStack {
                    
                    Button(action: {
                        agoraKit.leaveChannel(nil)
                        vc = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Primary"))
                    }
                    Spacer()
                } .padding()
                Spacer()
                Button(action: {
                    isMuted.toggle()
                    
                        agoraKit.muteLocalAudioStream(isMuted)
                    
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 125, height: 125)
                        .foregroundColor(Color("Primary"))
                        Image(systemName: isMuted ? "mic.slash" : "mic")
                        .foregroundColor(.white)
            }
                }
            }
            VCGridView(users: usersInVC, isMuted: $isMuted, agoraKit: $agoraKit)
    }
        .onDisappear() {
            let db = Firestore.firestore()
           
            let ref2 = db.collection("groups").document(group!.groupID)
            ref2.getDocument{document, error in
                
                if let document = document, document.exists {
                    
             
                    let groupListCast = document.data()?["userInVC"] as? [String]
                    
                    if var currentGroups = groupListCast {
                        for id in currentGroups {
                            if id == userData.userID {
                        currentGroups.remove(at: i)
                            }
                            i += 1
                        }
                        ref2.updateData(
                            [
                                "userInVC": currentGroups
                            ]
                        )
                        i = 0
        }
                }
            }
        }
    }
    
    func loadUsersInVC(performAction: @escaping ([Groups]) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document(group!.groupID)
        var userList:[Groups] = []
        //Get every single document under collection users
    
     docRef.getDocument { (document, error) in
         
                let result = Result {
                 try document?.data(as: Groups.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            userList.append(user)
                 
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
     
            
              performAction(userList)
        }
    }
    func loadUsersData(performAction: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
        for userInVC in group!.userInVC {
            let docRef = db.collection("users").document(userInVC!)
        var userList:[User] = []
        //Get every single document under collection users
    
     docRef.getDocument(){ (document, error) in
         
                let result = Result {
                 try document?.data(as: User.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            userList.append(user)
                 
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
     
            
              performAction(userList)
        }
    }
    }
    func initializeAgoraEngine() {
       // Initialize the AgoraRtcEngineKit object.
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "8345f101e56845fda7205089fef7824d", delegate: nil)
    }
    func joinChannel() {
        // Join a channel with a token.
        UIApplication.shared.isIdleTimerDisabled = true
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.setAudioProfile(.speechStandard, scenario: .chatRoomGaming)
        agoraKit.joinChannel(byToken: token, channelId: name, info: nil, uid: 0) { (channel, uid, elapsed) -> Void in}
               
            }
            
    }

class VideoEngine: NSObject {
    // init AgoraRtcEngineKit
    
   
   
}

extension VideoEngine: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
       
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
       
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
       
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
      
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
      
    }
}
}
