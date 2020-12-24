//
//  VideoChat.swift
//  StudyHub
//
//  Created by Andreas Ink on 11/26/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import AgoraRtcKit
import Alamofire
import ARKit

struct VideoChatView : View {
    @State var isLocalInSession = false
    @State var isLocalAudioMuted = false
    
    @State var isRemoteInSession = false
    @State var isRemoteVideoMuted = true
    
    @Binding var room: String
  @State   var localCanvas = VideoCanvas()
    @State   var remoteCanvas = VideoCanvas()
    @Binding var video: Bool
    @Binding var tapped: Bool
    private let videoEngine = VideoEngine()
    
    private var rtcEngine: AgoraRtcEngineKit {
        get {
            return videoEngine.agoraEngine
        }
    }
   
    var body: some View {
        GeometryReader { geometry in
        ZStack() {
            VideoSessionView(
                backColor: Color(.white),
                backImage: Image("big_logo"),
                hideCanvas: isRemoteVideoMuted || !isRemoteInSession || !isLocalInSession,
                canvas: remoteCanvas
            ).edgesIgnoringSafeArea(.all)
            
            .onDisappear() {
                video = false
                rtcEngine.stopAudioRecording()
                rtcEngine.stopPreview()
            }
            .onAppear() {
                video = true
              
            }
            VStack {
                HStack {
                    Text(room)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("blueD")))
                    Spacer()
                    VideoSessionView(
                        backColor: Color("localBackColor"),
                        backImage: Image("logo"),
                        hideCanvas: !isLocalInSession,
                        canvas: localCanvas
                    ).frame(width: 84, height: 112)
                }.padding()
                Spacer(minLength: geometry.size.height/2.5)
                HStack {
                    Spacer()
                    Button(action: toggleLocalAudio) {
                        ZStack {
                   Image("mic")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    }
                    Spacer()
                    Button(action: {
                        toggleLocalSession()
                        video = false
                    }) {
                        ZStack {
                            Image("phone")
                             .resizable()
                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    }
                    Spacer()
                    Button(action: switchCamera) {
                        ZStack {
                            Image("cam")
                             .resizable()
                                .frame(width: 75, height: 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                               
                    }
                    }
                    Spacer()
                }.padding()
                Spacer(minLength: 75)
            }
            
            .padding(.vertical, 22)
        }.onAppear {
            // This is our usual steps for joining
            // a channel and starting a call.
            self.initializeAgoraEngine()
            self.setupVideo()
            self.setupLocalVideo()
            self.toggleLocalSession()
        }
    }
}
}
extension VideoChatView {
    func log(content: String) {
        print(content)
    }
}

fileprivate extension VideoChatView {
    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
       

       
        videoEngine.contentView = self
    }
    
    func setupVideo() {
        // In simple use cases, we only need to enable video capturing
        // and rendering once at the initialization step.
        // Note: audio recording and playing is enabled by default.
        rtcEngine.enableVideo()
       
        // Set video configuration
        // Please go to this page for detailed explanation
        // https://docs.agora.io/en/Voice/API%20Reference/oc/Classes/AgoraRtcEngineKit.html#//api/name/setVideoEncoderConfiguration:
        rtcEngine.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: AgoraVideoDimension640x360,
                frameRate: .fps15,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative
        ))
    }
    func setupLocalVideo2(uid: UInt) {
            
            
            let videoView = ARSCNView()
            videoView.tag = Int(uid)
            videoView.backgroundColor = UIColor.orange
            
    //        let videoCanvas = AgoraRtcVideoCanvas()
    //        videoCanvas.uid = uid
    //        videoCanvas.view = videoView
    //        videoCanvas.renderMode = .hidden
    //        agoraKit.setupLocalVideo(videoCanvas)
            
        //self.sceneView.delegate = self
            
          //  if isARSupported {
               
           // }
            
       
        }
    func setupLocalVideo() {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
       
        
       
        let videoCanvas = AgoraRtcVideoCanvas()
        
        videoCanvas.view = localCanvas.rendererView
        videoCanvas.renderMode = .hidden
       // videoCanvas.view = self.sceneView
        
       // let animoji = Animoji(frame: videoCanvas.view!.frame)
       // animoji.setPuppet(name: .cat)
       // videoCanvas.view = animoji
        rtcEngine.setupLocalVideo(videoCanvas)
        
        
    }
    
    func joinChannel() {
        // Set audio route to speaker
        rtcEngine.setDefaultAudioRouteToSpeakerphone(true)
        
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. One token is only valid for the channel name that
        // you use to generate this token.
        let request = AF.request("https://studyhub1.herokuapp.com/access_token?channel=\("test")&uid=0")

               request.responseJSON { (response) in
       print(response)
                   guard let tokenDict = response.value as! [String : Any]? else { return }
               let token = tokenDict["token"] as! String
                rtcEngine.joinChannel(byToken: token, channelId: "test", info: nil, uid: 0, joinSuccess: nil)
                  
            

         
        
        
    }
    }
  
    func leaveChannel() {
        // leave channel and end chat
        rtcEngine.leaveChannel(nil)
    
}
}

fileprivate extension VideoChatView {
    func toggleLocalSession() {
        isLocalInSession.toggle()
        if isLocalInSession {
            joinChannel()
        } else {
            leaveChannel()
        }
    }
    
    func switchCamera() {
        rtcEngine.switchCamera()
    }
    
    func toggleLocalAudio() {
        isLocalAudioMuted.toggle()
        // mute/unmute local audio
        rtcEngine.muteLocalAudioStream(isLocalAudioMuted)
    }
}

class VideoEngine: NSObject {
    // init AgoraRtcEngineKit
    
    lazy var agoraEngine = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    var contentView: VideoChatView?
}

extension VideoEngine: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        contentView?.log(content: "did join channel")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        contentView?.log(content: "did leave channel")
        contentView?.isLocalAudioMuted = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        contentView?.isRemoteInSession = true
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        contentView?.isRemoteInSession = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = contentView?.remoteCanvas.rendererView
        videoCanvas.renderMode = .hidden
        videoCanvas.uid = uid
        agoraEngine.setupRemoteVideo(videoCanvas)

        contentView?.isRemoteVideoMuted = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        contentView?.isRemoteVideoMuted = muted
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        contentView?.log(content: "did occur warning: \(warningCode.rawValue)")
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        contentView?.log(content: "did occur error: \(errorCode.rawValue)")
    }
}
struct VideoSessionView : View {
    var backColor: Color?
    var backImage = Image("logo2")
    var hideCanvas: Bool = false
    var canvas: VideoCanvas?
    
    var body: some View {
        ZStack {
            if hideCanvas {
                backColor
                backImage
            } else {
                canvas
                   // .padding(.bottom, 200)
            }
        }
    }
}
struct VideoCanvas : UIViewRepresentable {
    var rendererView = UIView()
    
    func makeUIView(context: Context) -> UIView {
        rendererView.backgroundColor = UIColor.gray
        
        return rendererView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct VideoView_Previews : PreviewProvider {
    static var previews: some View {
        VideoCanvas()
    }
}

var AppID: String = "8345f101e56845fda7205089fef7824d"
/* assign Token to nil if you have not enabled app certificate
 * before you deploy your own token server, you can easily generate a temp token for dev use
 * at https://dashboard.agora.io note the token generated are allowed to join corresponding room ONLY.
 */
/* 如果没有打开鉴权Token, 这里的token值给nil就好
 * 生成Token需要参照官方文档部署Token服务器，开发阶段若想先不部署服务器, 可以在https://dashbaord.agora.io生成
 * 临时Token. 请注意生成Token时指定的频道名, 该Token只允许加入对应的频道
 */
let Token: String? = "" //"006eaa67b77688d4349a73923b6ad82be4aIAArRPTMZfUdffeAQ4YWw0jZtXXvY4/+Em3weS5/xpp5WuIVUyEAAAAAEABEZ8flNk2MXwEAAQAzTYxf"
