//
//  PlayerInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

public protocol PlayerViewDelegate {
    func seekBarUpdate(_ value: Float)
}

public protocol PlayerViewFinishedDelegate {
    func playerHasLoaded()
    func playerStartsToPlay()
    func playerPause()
    func playerSeeksTo(_ value: Float)
}

public protocol PlayerViewSetter {
    func addPlayerAsSubview(_ player: PlayerView)
}
