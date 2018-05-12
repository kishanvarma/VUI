//
//  ImgNode.swift
//  ARText
//
//  Created by Kishan Varma on 4/15/18.
//  Copyright © 2018 Mark Zhong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ImgNode: SCNNode {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(anchor: ARPlaneAnchor, imagePath: String){
        super.init()
        
        let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let lavaMaterial = SCNMaterial()
        lavaMaterial.isDoubleSided = true
        if(imagePath == ""){
                let lavaImage = UIImage(named: "Lava")
                lavaMaterial.diffuse.contents = lavaImage
        }else{
                let lavaImage = UIImage(contentsOfFile: imagePath)
                lavaMaterial.diffuse.contents = lavaImage
        }
       
        
        plane.materials = [lavaMaterial]
        
        self.geometry = plane
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        self.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        print("returning /n ")
    }
   /*
     init(layer : bool , anchor: ARPlaneAnchor){
        
         let layer = CALayer()
         layer.frame = CGRect(x:0, y:0, width:100, height:100)
         layer.backgroundColor = UIColor.orange.cgColor
         let position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
         
         let textLayer = CATextLayer()
         textLayer.frame = layer.bounds
         textLayer.fontSize = layer.bounds.size.height
         textLayer.string = "My name is Kishan Varma"
         textLayer.alignmentMode = kCAAlignmentLeft
         textLayer.foregroundColor = UIColor.green.cgColor
         textLayer.display()
         layer.addSublayer(textLayer)
         
         let box = SCNBox(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z),length: CGFloat(anchor.extent.x),chamferRadius: 0.01 )
         let boxNode = SCNNode(geometry: box)
         box.firstMaterial?.locksAmbientWithDiffuse = true
         boxNode.position = position
         
         box.firstMaterial?.diffuse.contents = layer
         return boxNode
         //scene.rootNode.addChildNode(boxNode)
    }
   */
}
