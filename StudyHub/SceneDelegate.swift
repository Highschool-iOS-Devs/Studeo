//
//  SceneDelegate.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @State var myGroups = [Groups]()
    @State var room = "Test"
    @State var video = false
    @State var tapped = false
    @State var add = false
    @State var settings = false
    @State var i = 0
    @StateObject var userData = UserData()
    @StateObject var viewRouter = ViewRouter()
    // @State var user = User(id: UUID(), firebaseID: "", name: "", email: "", profileImageURL: URL(string: ""), interests: [UserInterestTypes](), groups: [String](), isMentor: false, recentGroups: [String](), recentPeople: [String](), studyHours: [Double](), studyDate: [String](), all: 0.0, month: 0.0, day: 0.0, description: "", isAvailable: false, dms: [String]())
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(userData: userData, viewRouter: viewRouter)//IntroMentor(settings: $settings, add: $add)//VideoChatView(room: $room, video: $video, tapped: $tapped)
            .environmentObject(ViewRouter.shared)
            .environmentObject(UserData.shared)
            .environmentObject(QuizRouter.shared)
        
        
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

