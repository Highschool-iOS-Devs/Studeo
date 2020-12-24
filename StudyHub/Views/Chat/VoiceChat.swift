//
//  VoiceChat.swift
//  StudyHub
//
//  Created by Andreas on 12/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import AgoraRtcKit
struct VoiceChat: View {
    @State var agoraKit: AgoraRtcEngineKit
    @State var token = ""
    @State var name = ""
    @State var isMuted = false
    var body: some View {
        ZStack {
        Color("Background").edgesIgnoringSafeArea(.all)
            .onDisappear() {
                agoraKit.leaveChannel(nil)
                    UIApplication.shared.isIdleTimerDisabled = false
            }
            .onAppear() {
                initializeAgoraEngine()
                joinChannel()
            }
        
            VStack {
                Spacer()
               
                Button(action: {
                    isMuted.toggle()
                    
                        agoraKit.muteLocalAudioStream(isMuted)
                    
                }) {
                    ZStack {
                        Circle()
                            .frame(width: 75)
                        .foregroundColor(Color("Primary"))
                        Image(systemName: isMuted ? "mic.slash" : "mic")
                        .foregroundColor(.white)
            }
                }
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
