//
//  ARCameraVC.swift
//  Instagram
//
//  Created by Bobby Negoat on 1/5/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARCameraVC: UIViewController,ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
        {didSet{self.sceneView.delegate = self
            sceneView.showsStatistics = true
            sceneView.antialiasingMode = .multisampling4X}}
    
    fileprivate var nodeModel:SCNNode!
    fileprivate let nodeName = "ball"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a new scene
        createScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //session configuration
        sessionConfigue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //stop AR session
        stopSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}//ARCameraVC class over line

//custom functions
extension ARCameraVC{
    
    fileprivate func createScene(){
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let modelScene = SCNScene(named: "art.scnassets/ball/obj_ball.scn")!
        nodeModel =  modelScene.rootNode.childNode(withName: nodeName, recursively: true)
    }
    
    fileprivate func sessionConfigue(){
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    fileprivate func stopSession(){
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    fileprivate func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeName {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
}

//ARSCNViewDelegate
extension ARCameraVC{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero
                
                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
