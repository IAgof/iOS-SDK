//
//  PlayerInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 17/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

open class PlayerInteractor: NSObject, PlayerInteractorInterface {

    open func findVideosToPlay() -> (URL) {
        return PlayerProvider().getTestVideo() as (URL)
    }
}
