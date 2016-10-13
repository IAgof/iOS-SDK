//
//  Music.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public class Music: Audio {
    
    private var musicTitle:String!
    private var author:String!
    private var iconResourceId:String!
    private var musicResourceId:String!
    public var musicSelectedResourceId:String!
    private var musicSet:Bool! = false
    
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
    
    public func getMusicTitle()->String{
        return self.musicTitle
    }
    
    public func setMusicTitle(title:String){
        self.musicTitle = title
    }
    
    public func getAuthor()->String{
        return self.author
    }
    
    public func setAuthor(author:String){
        self.author = author
    }
    
    public func getIconResourceId()->String{
        return self.iconResourceId
    }
    
    public func setIconResourceId(icon:String){
        self.iconResourceId = icon
    }
    
    public func getMusicResourceId()->String{
        return self.musicResourceId
    }
    
    public func setMusicResourceId(musicResource:String){
        self.musicResourceId = musicResource
    }
    
    public func getMusicStateSetOrNot()->Bool{
        return self.musicSet
    }
    
    public func setMusicStateSetOrNot(state:Bool){
        self.musicSet = state
    }
}