//
//  Audio.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public enum MusicResource {
    case music
    case originalAudio
    case voiceOver
    case externalAudio
    
    public var icon: UIImage{
        
        //TODO: Set correct icons
        switch self {
        case .music:
            return #imageLiteral(resourceName: "common_icon_play_normal")
        case .originalAudio:
            return #imageLiteral(resourceName: "common_icon_play_normal")
        case .voiceOver:
            return #imageLiteral(resourceName: "common_icon_play_normal")
        case .externalAudio:
            return #imageLiteral(resourceName: "common_icon_play_normal")
        }
    }
}

open class Audio: Media {
    public var musicResource: MusicResource
    
    public init(title: String, mediaPath: String, musicResource: MusicResource = .externalAudio) {
        self.musicResource = musicResource
        super.init(title: title, mediaPath: mediaPath)
    }
}
