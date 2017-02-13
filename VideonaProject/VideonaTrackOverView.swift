//
//  VideonaTrackOverView.swift
//  testDrawingPortionsOverVideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 3/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

public class VideonaTrackOverView: UIView {
    public var trackLayers:[TrackLayer] = []
    
    //It makes clear to subviews
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    public func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        setTrackLayers()
        
        CATransaction.commit()
    }
    
    public func setTrackLayers(){
        for layer in trackLayers{
            setTrackedAreaView(layer: layer)
        }
    }
    
    public func setTrackedAreaView(layer: TrackLayer){
        let width = self.frame.width
        let height = self.frame.height
        
        layer.frame = CGRect(x: 0,y: 0,width: width,height: height)
    }
    
    public func updateLayer(portionData: TrackModel,
                     position:Int) {
        if trackLayers.indices.contains(position){
            let trackLayer = trackLayers[position]
            trackLayer.trackValues = portionData

            setTrackedAreaView(layer: trackLayer)
        }
    }
    
    public func addLayer(portionData: TrackModel){
        let trackLayer = TrackLayer()
        trackLayer.trackValues = portionData
        trackLayers.append(trackLayer)
        
        trackLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(trackLayer)
        
        updateLayerFrames()
    }
    
    public func removeLayerFromPosition(position:Int){
        if trackLayers.indices.contains(position){
            let layer = trackLayers[position]
            layer.removeFromSuperlayer()
            trackLayers.remove(at: position)
            updateLayerFrames()
        }
    }
}
