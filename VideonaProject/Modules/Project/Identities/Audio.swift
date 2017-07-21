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
    
    public var iconExpand: UIImage{
        
        //TODO: Set correct icons
        switch self {
        case .music:
            return #imageLiteral(resourceName: "activity_edit_audio_music_expand")
        case .originalAudio:
            return #imageLiteral(resourceName: "activity_edit_audio_sound_expand")
        case .voiceOver:
            return #imageLiteral(resourceName: "activity_edit_audio_voiceover_expand")
        case .externalAudio:
            return #imageLiteral(resourceName: "common_icon_play_normal")
        }
    }
    
    public var iconShrink: UIImage{
        
        //TODO: Set correct icons
        switch self {
        case .music:
            return #imageLiteral(resourceName: "activity_edit_audio_music_shrink")
        case .originalAudio:
            return #imageLiteral(resourceName: "activity_edit_audio_sound_shrink")
        case .voiceOver:
            return #imageLiteral(resourceName: "activity_edit_audio_voiceover_shrink")
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
