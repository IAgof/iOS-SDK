//
//  Music.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class Music: Audio {
    
    fileprivate var musicTitle:String!
    fileprivate var author:String!
    fileprivate var iconResourceId:String!
    fileprivate var musicResourceId:String!
    open var musicSelectedResourceId:String!
    fileprivate var musicSet:Bool! = false
    public static let DEFAULT_MUSIC_VOLUME = 0.5

    public var  volume = DEFAULT_MUSIC_VOLUME

    public init(title:String,
                  author:String,
                  iconResourceId:String,
                  musicResourceId:String,
                  musicSelectedResourceId:String){
        
        super.init(title: title, mediaPath: musicResourceId)
        
        self.author = author
        self.musicTitle = title
        self.iconResourceId = iconResourceId
        self.musicResourceId = musicResourceId
        self.musicSelectedResourceId = musicSelectedResourceId
    }
    
    open func getMusicTitle()->String{
        return self.musicTitle
    }
    
    open func setMusicTitle(_ title:String){
        self.musicTitle = title
    }
    
    open func getAuthor()->String{
        return self.author
    }
    
    open func setAuthor(_ author:String){
        self.author = author
    }
    
    open func getIconResourceId()->String{
        return self.iconResourceId
    }
    
    open func setIconResourceId(_ icon:String){
        self.iconResourceId = icon
    }
    
    open func getMusicResourceId()->String{
        return self.musicResourceId
    }
    
    open func setMusicResourceId(_ musicResource:String){
        self.musicResourceId = musicResource
    }
    
    open func getMusicStateSetOrNot()->Bool{
        return self.musicSet
    }
    
    open func setMusicStateSetOrNot(_ state:Bool){
        self.musicSet = state
    }
}
