//
//  Profile.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 20/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

open class Profile: NSObject {
    
    static let sharedInstance = Profile()
    /**
     * possible profileTypes
     */
    public enum ProfileType {
        case free
        case pro
    }
    
    /**
     * Resolution of the Video objects in a project
     */
    fileprivate var resolution:String?
    
    /**
     * Video bit rate
     */
    fileprivate var videoQuality:String?
    
    /**
     * Maximum length of the project in millseconds
     * if the value is negative the project duration has no limitation
     */
    fileprivate var maxDuration:Double?
    
    /**
     * type of profile
     */
    fileprivate var profileType:ProfileType?
    
    public var frameRate:Int = 30
    
    /**
     * Constructor of minimum number of parameters. In this case coincides with parametrized
     * constructor and therefore is the default constructor. It has all possible atributes for the
     * profile object.
     * <p/>
     * There can be only a single instance of a profile, and therefore this constructor can only be
     * accessed through the factory.
     *
     * @param resolution  - Maximum resolution allowed for the profile.
     * @param maxDuration - Maximum video duration allowed for the profile.
     * @param type        - Profile type.
     */
    init(resolution:String,
         videoQuality:String,
         maxDuration:Double,
         type:ProfileType) {
        self.resolution = resolution
        self.maxDuration = maxDuration
        self.profileType = type
        self.videoQuality = videoQuality
    }
    
    public init(resolution:String,
         videoQuality:String,
         frameRate:Int){
        self.resolution = resolution
        self.videoQuality = videoQuality
        self.frameRate = frameRate
    }
    
    override init(){
        if (profileType == ProfileType.free) {
            self.resolution = AVCaptureSessionPreset1280x720
            self.videoQuality = AVCaptureSessionPresetHigh
            self.maxDuration = 1000
            self.profileType = ProfileType.free
        } else {
            self.resolution = AVCaptureSessionPreset1920x1080
            self.videoQuality = AVCaptureSessionPresetHigh
            self.maxDuration = -1
            self.profileType = ProfileType.pro
        }

    }
    
    /**
     * Profile factory.
     *
     * @param profileType
     * @return - profile instance.
     */
    static open func getInstance(_ profileType:ProfileType) ->Profile {
        return sharedInstance
    }
    
    //getter and setter.
    open func getResolution() -> String {
        return self.resolution!
    }
    
    open func setResolution(_ resolution:String) {
        if profileType == ProfileType.pro {
            self.resolution = resolution
        }
    }
    
    //getter and setter video quality
    open func getQuality() -> String {
        return self.videoQuality!
    }
    
    open func setQuality(_ quality:String) {
        self.videoQuality = quality
    }
    
    open func getMaxDuration() ->Double{
        return maxDuration!
    }
    
    open func setMaxDuration(_ maxDuration:Double) {
        if profileType == ProfileType.pro {
            self.maxDuration = maxDuration
        }
    }
    
    open func getProfileType() -> ProfileType{
        return self.profileType!
    }
}
