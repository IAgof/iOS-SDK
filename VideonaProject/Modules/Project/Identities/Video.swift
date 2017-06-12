//
//  Video.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

open class Video: Media {
    
    open var videoURL:URL = URL(fileURLWithPath: ""){
        didSet{
            self.PHAssetForFileURL(url: videoURL as NSURL, completion: {
                phAsset,hasAsset in
                if hasAsset{
                    self.videoPHAsset = phAsset!
                }
            })
        }
    }
    
    open var videoPHAsset:PHAsset = PHAsset()
    fileprivate var isSplit:Bool!
    fileprivate var position:Int!
    open var textToVideo:String = ""
    open var textPositionToVideo:Int = 0

    override public init(title: String, mediaPath: String) {
        super.init(title: title, mediaPath: mediaPath)
        
        isSplit = false
    }
    
    open func copyWithZone(_ zone: NSZone?) -> AnyObject {
        let copy = Video(title: title,
                         mediaPath: mediaPath)
        copy.setIsSplit(isSplit)
        copy.setPosition(position)
        copy.fileStopTime = fileStopTime
        copy.setStopTime(trimStopTime)
        copy.setStartTime(trimStartTime)
        copy.textToVideo = textToVideo
        copy.textPositionToVideo = textPositionToVideo
        copy.videoURL = videoURL
        copy.uuid = UUID().uuidString
        
        return copy
    }
    
    open func mediaRecordedFinished(){
        let asset = AVAsset(url: videoURL)
        
        fileStartTime = 0.0
        fileStopTime = asset.duration.seconds
        trimStartTime = fileStartTime
        trimStopTime = fileStopTime
    }
    
    open func setDefaultVideoParameters(){
        let asset = AVAsset(url: videoURL)
        
        fileStartTime = 0.0
        fileStopTime = asset.duration.seconds
   }
    
    open func getIsSplit() -> Bool {
        return isSplit
    }
    
    open func setIsSplit(_ state:Bool){
        self.isSplit = state
    }
    
    open func getPosition()->Int{
        return self.position
    }
    
    open func setPosition(_ position:Int){
        self.position = position
    }
    
    private func PHAssetForFileURL(url: NSURL,completion:@escaping (_ asset:PHAsset?,_ isHaveFound:Bool)->Void){
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.deliveryMode = .fastFormat
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isSynchronous = true
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: nil)
        for  i in  0...(fetchResult.count - 1) {
            let asset = fetchResult[i]
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {
                avAsset,audioMix, info in
                
                if let urlAsset = avAsset as? AVURLAsset{
                    let urlAssetAbsString = (urlAsset.url.absoluteString as NSString).lastPathComponent
                    let urlAbsString = (url.absoluteString! as NSString).lastPathComponent
                    
                    if urlAssetAbsString == urlAbsString{
                        completion(asset,true)
                    }else{
                        if i == (fetchResult.count - 1){
                            completion(nil,false)
                        }
                    }
                }
            })
        }
    }
}
