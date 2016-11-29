//
//  GetActualProjectTextCALayerAnimationUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 20/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class GetActualProjectTextCALayerAnimationUseCase:NSObject {
    public func getCALayerAnimation(project:Project)-> CALayer {
        let videos = project.getVideoList()
        
        let layers :[CALayer] = getTextLayersAnimated(videoList: videos)
        
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
            
            if video.textToVideo != "" {
                let image = GetImageByTextUseCase().getTextImage(text: video.textToVideo,
                                                                 attributes:CATextLayerAttributes().getAlignmentAttributesByType(type: textPosition))
                
                let textImageLayer = CALayer()
                textImageLayer.contents = image.cgImage
                textImageLayer.frame = CGRect(x: 0.0, y: 0.0,
                                              width: image.size.width,height: image.size.height)
                textImageLayer.contentsScale = UIScreen.main.scale
                textImageLayer.opacity = 0.0
                
                addAnimationToLayer(overlay: textImageLayer,
                                    timeAt: timeToInsertAnimate,
                                    duration: video.getDuration())
                
                layers.append(textImageLayer)
                
                timeToInsertAnimate += video.getDuration()
            }
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
        animationEntrada.keyTimes = [0.0, 0.01, 0.99, 1.0]
        animationEntrada.values = [0.0, 1.0, 1.0, 0.0]
        animationEntrada.isRemovedOnCompletion = false
        animationEntrada.fillMode = kCAFillModeForwards
        overlay.add(animationEntrada, forKey:"animateOpacity")
    }
}
