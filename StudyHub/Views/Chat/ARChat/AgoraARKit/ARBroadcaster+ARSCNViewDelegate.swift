//
//  ARBroadcaster+ARSCNViewDelegate.swift
//  Agora-ARKit Framework
//
//  Created by Hermes Frangoudis on 1/15/20.
//  Copyright © 2020 Agora.io. All rights reserved.
//

import ARKit

extension ARBroadcaster: ARSCNViewDelegate {
    // MARK: Render delegate
    open func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // scene will render
    }
    
    open func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // renderer updated
    }
    
    open func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // scene did render
    }
    
    open func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // anchor plane detection
    }
    

    
    open func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // anchor plane is removed
    }
    open func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            
            guard let device = sceneView.device else {
                return nil
            }
            
            let faceGeometry = ARSCNFaceGeometry(device: device)
            
            let node = SCNNode(geometry: faceGeometry)
            
            node.geometry?.firstMaterial?.fillMode = .lines
            
            return node
        }
        
    open func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            
            guard let faceAnchor = anchor as? ARFaceAnchor,
                let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                    return
            }
            
            faceGeometry.update(from: faceAnchor.geometry)
            
        }
}

