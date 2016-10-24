//
//  GetActualProjectTextCALayerAnimationUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 20/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

public class GetActualProjectTextCALayerAnimationUseCase:NSObject {
    public func getCALayerAnimation(project:Project)-> CALayer {
        let videos = project.getVideoList()
        
        let layers :[CALayer] = getTextLayersAnimated(videos)
        
        let parentLayer = CALayer()
        
        for layer in layers{
            parentLayer.addSublayer(layer)
        }
        return parentLayer
    }
    
    
    public func getTextLayersAnimated(videoList:[Video])-> [CALayer]{
        var layers :[CALayer] = []
        
        var timeToInsertAnimate = 0.0
        
        for video in videoList{
            guard let textPosition =  CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else {
                print("Not valid position")
                return []}
            
            let image = GetImageByTextUseCase().getTextImage(video.textToVideo,
                                                             attributes:CATextLayerAttributes().getAlignmentAttributesByType(textPosition))
            
            let textImageLayer = CALayer()
            textImageLayer.contents = image.CGImage
            textImageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            textImageLayer.contentsScale = UIScreen.mainScreen().scale
            textImageLayer.opacity = 0.0
            
            addAnimationToLayer(textImageLayer,
                                timeAt: timeToInsertAnimate,
                                duration: video.getDuration())
            
            layers.append(textImageLayer)
            
            timeToInsertAnimate += video.getDuration()
        }
        return layers
    }
    
   public func addAnimationToLayer(overlay:CALayer,
                             timeAt:Double,
                             duration:Double){
        //Animacion de entrada
        let animationEntrada = CAKeyframeAnimation(keyPath:"opacity")
        animationEntrada.beginTime = AVCoreAnimationBeginTimeAtZero + timeAt
        animationEntrada.duration = duration
        animationEntrada.keyTimes = [0, 1/100.0, 99/100.0, 1]
        animationEntrada.values = [0.0, 1.0, 1.0, 0.0]
        animationEntrada.removedOnCompletion = false
        animationEntrada.fillMode = kCAFillModeForwards
        overlay.addAnimation(animationEntrada, forKey:"animateOpacity")
    }
}