//
//  VideoPlayer.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/12/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import UIKit
import AVKit




class Video: UIViewController {
    
   


    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        let file = "test.MP4".components(separatedBy: ".")

          guard let path = Bundle.main.path(forResource: file[0], ofType:file[1]) else {
              debugPrint( "\(file.joined(separator: ".")) not found")
              return
          }
          let player = AVPlayer(url: URL(fileURLWithPath: path))

          let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
          self.view.layer.addSublayer(playerLayer)
          player.play()
        loopVideo(videoPlayer: player)
        }
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
}

struct VideoView: UIViewControllerRepresentable {
  
  
    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoView>) -> UIViewController {
        let picker = Video()
        
                      
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VideoView>) {
       
    }
}

