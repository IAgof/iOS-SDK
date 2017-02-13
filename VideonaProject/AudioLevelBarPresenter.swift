//
//  AudioLevelBarPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

open class AudioLevelBarPresenter:AudioLevelBarPresenterInterface,AudioLevelBarInteractorDelegate{
    //MARK : VIPER
    var delegate:AudioLevelBarPresenterDelegate
    var interactor:AudioLevelBarInteractorInterface?
    
    init(controller:AudioLevelBarView){
        delegate = controller
        interactor = AudioLevelBarInteractor(presenter: self)
    }
    
    func getAudioLevel() {
        interactor?.startToGetAudioLevel()
    }
    
    //MARK: Interactor Delegate

    func setAudioLevel(_ value: Float) {
        let level = 1 - (value / (-50))
        delegate.setAudioLevelToView(level)
    }
}
