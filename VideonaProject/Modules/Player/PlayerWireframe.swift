//
//  PlayerWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//
import Foundation
import UIKit

let playerViewIdentifier = "PlayerView"

open class PlayerWireframe : NSObject{
    
    open var playerPresenter : PlayerPresenter?
    open var presentedView : PlayerView?
    
    open func presentPlayerInterfaceFromViewController(_ viewController: UIViewController) {
        let playerView : PlayerView
        let playerSetter = viewController as? PlayerViewSetter
        let playerDelegate = viewController as? PlayerViewDelegate
        let playerStateDelegate = viewController as? PlayerViewFinishedDelegate
        
        if presentedView == nil{
            playerView = self.playerView()
        }else{
            playerView = presentedView!
        }
        
        playerView.eventHandler = playerPresenter
        playerView.delegate = playerDelegate
        playerView.state = playerStateDelegate
        playerPresenter?.playerDelegate = playerView
        
        presentedView = playerView        
        guard let setter = playerSetter else{return}
        setter.addPlayerAsSubview(playerView)
    }
    
    open func getPlayerPresenter()->PlayerPresenter{
        return playerPresenter!
    }
    
    open func playerView() -> PlayerView {
        let playerView: PlayerView = PlayerView.instanceFromNib() as! PlayerView
        return playerView
    }
    
}
